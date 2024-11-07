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
    // MARK: - User, UserAppData 통신
    var userAppDataListeners: [ListenerRegistration] = []
    
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
    
    func setUpListenersForUserAppData(userIDs: [String], handler: @escaping (Result<UserAppData, Error>) -> Void) {
        
        let db = Firestore.firestore()
        for userID in userIDs {
            let docRef = db.collection("userAppData").document(userID)
            
            let listener = docRef
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
            userAppDataListeners.append(listener)
        }
        
    }
    
    
    // MARK: - TeamMetaData 통신
    func createNewTeamInFirestore(teamData: TeamMetaData, handler: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("teamMetaData").document(teamData.inviteCode)
        
        docRef.getDocument { (document, error) in
            if let document, document.exists {
                handler(.failure(FirebaseError(errorMessage: "Team already exists")))
                return
            }
        }
        
        docRef.setData([
            "hostID" : teamData.hostID,
            "inviteCode" : teamData.inviteCode,
            "teamName" : teamData.teamName,
            "memberIDs": teamData.memberIDs
        ])
        handler(.success("Created new team"))
    }
    
    func addNewMemberToTeam(teamCode: String, userID: String, handler: @escaping (Result<TeamMetaData, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("teamMetaData").document(teamCode)
        
        docRef.getDocument { (document, error) in
            if let document, document.exists {
                docRef.updateData([
                    "memberIDs": FieldValue.arrayUnion([userID])
                ])
                var members = document["memberIDs"] as? [String] ?? []
                members.append(userID)
                let teamData  = TeamMetaData(memberIDs: members,
                                             teamName: document["teamName"] as? String ?? "",
                                             inviteCode: document["inviteCode"] as? String ?? "",
                                             hostID: document["hostID"] as? String ?? "")
                handler(.success(teamData))
            } else {
                handler(.failure(FirebaseError(errorMessage: "Team does not exist exists")))
                return
            }
        }
    }
    
}


class FirebaseError: Error {
    let errorMessage: String
    
    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
