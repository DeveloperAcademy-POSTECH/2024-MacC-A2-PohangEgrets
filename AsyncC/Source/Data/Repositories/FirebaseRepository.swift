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
    
}
