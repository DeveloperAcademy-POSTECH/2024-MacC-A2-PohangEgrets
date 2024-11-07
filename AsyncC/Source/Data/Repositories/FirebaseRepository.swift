//
//  Empty.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/6/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class FirebaseRepository: FirebaseRepositoryProtocol
{
    func setUserAppData(
        id: String,
        appName: String,
        epochSeconds: Int
    ) {
        let db = Firestore.firestore()
        let docRef = db.collection("userAppData").document(id)
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.exists {
                    docRef.updateData([
                        "appData": FieldValue.arrayUnion([["appName": appName, "timeStamp": epochSeconds]])
                    ])
                } else {
                    db.collection("userAppData").document(id).setData([
                        "userID": id,
                        "appData": [["appName": appName, "timeStamp": epochSeconds]]
                    ])
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "No error description")")
            }
        }
    }
    
    func setUsers(
        id: String,
        email: String,
        name: String
    ) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(id)
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.exists {
                    docRef.updateData([
                        "id": id,
                        "email": email,
                        "name": name
                    ])
                } else {
                    db.collection("users").document(id).setData([
                        "id": id,
                        "email": email,
                        "name": name
                    ])
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "No error description")")
            }
        }
    }
    
    func setUpListenerForUserAppData(userID: String, handler: @escaping (Result<UserAppData, any Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("userAppData").document(userID)
        
        docRef
            .addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    if let error {
                        handler(.failure(error))
                    } else {
                        print("Error fetching document")
                    }
                    return
                }
                guard let data = document.data() else {
                    if let error {
                        handler(.failure(error))
                    } else {
                        print("Document data was empty.")
                    }
                    return
                }
                
                let appDataTuples: [(String, Int)] = (data["appData"] as? [[String: Any]])?.compactMap { entry in
                    if let appName = entry["appName"] as? String,
                       let timeStamp = entry["timeStamp"] as? Int {
                        return (appName, timeStamp)
                    } else {
                        return nil
                    }
                } ?? []
                if !appDataTuples.isEmpty, let id = data["userID"] as? String {
                    handler(.success(UserAppData(userID: id, appData: appDataTuples)))
                }
            }
        
    }
    
}
