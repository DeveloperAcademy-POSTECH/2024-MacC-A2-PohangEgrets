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
    // MARK: - User, UserAppData 통신 및 관리
    var userAppDataListeners: [ListenerRegistration] = []
    
    func setTrackingActive(id: String, isActive: Bool) {
        let db = Firestore.firestore()
        let docRef = db.collection("userAppData").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.updateData(["trackingActive": isActive]) { error in
                    if let error = error {
                        print("Failed to update trackingActive: \(error.localizedDescription)")
                    }
                }
            } else {
                docRef.setData([
                    "userID": id,
                    "trackingActive": true
                ]) { error in
                    if let error = error {
                        print("Failed to initialize trackingActive: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func setUpListenerForTrackingActive(for userID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("userAppData").document(userID)
        docRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let document = documentSnapshot, let data = document.data() {
                let isActive = data["trackingActive"] as? Bool ?? true
                completion(.success(isActive))
            } else {
                completion(.failure(FirebaseError(errorMessage: "Document does not exist")))
            }
        }
    }

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
                db.collection("users").document(id).setData([
                    "id": id,
                    "email": email,
                    "name": name
                ])
            } else {
                print("Error: \(error?.localizedDescription ?? "No error description")")
            }
        }
    }
    
    func updateUsers(
        id: String,
        email: String? = nil,
        name: String? = nil
    ) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var dataToUpdate: [String: Any] = [:]
                
                if let email = email {
                    dataToUpdate["email"] = email
                }
                
                if let name = name {
                    dataToUpdate["name"] = name
                }
                
                if !dataToUpdate.isEmpty {
                    db.collection("users").document(id).setData(dataToUpdate, merge: true)
                } else {
                    print("No fields to update.")
                }
            } else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("Document does not exist.")
                }
            }
        }
    }
    
    func checkExistUserBy(userID: String, completion: @escaping (Bool, String?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false, nil)
                return
            }
            
            if let document = document, document.exists {
                if let name = document.data()?["name"] as? String {
                    completion(true, name)
                } else {
                    completion(true, nil)
                }
            } else {
                completion(false, nil)
            }
        }
    }
    
    func sendEmoticon(
        sender: String,
        emoticon: String,
        receiver: String
    ) {
        let db = Firestore.firestore()
        let docRef = db.collection("emoticons").document(receiver)
        docRef.getDocument { (document, error) in
            if let document = document {
                db.collection("emoticons").document(receiver).setData([
                    "sender": sender,
                    "emoticon": emoticon,
                    "receiver": receiver
                ])
            } else {
                print("Error: \(error?.localizedDescription ?? "No error description")")
            }
        }
    }
    
    func setUpListenerForEmoticons(userID: String, handler: @escaping (Result<Emoticon, any Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("emoticons").document(userID)
        
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
                
                guard let sender = data["sender"] as? String,
                      let receiver = data["receiver"] as? String,
                      let emoticonRawValue = data["emoticon"] as? String,
                      let emoticonOption = Emoticon.emoticonOption(rawValue: emoticonRawValue) else {
                    let mappingError = NSError(domain: "MappingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
                    handler(.failure(mappingError))
                    return
                }
                handler(.success(Emoticon(receiver: receiver, emoticon: emoticonOption, sender: sender)))
            }
    }
    
    func setUpListenersForUserAppData(userIDToIgnore: String, userIDsToTrack: [String], handler: @escaping (Result<UserAppData, Error>) -> Void) {
        let db = Firestore.firestore()
        for userID in userIDsToTrack {
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
    
    func removeListenersForUserAppData() {
        for listener in userAppDataListeners {
            listener.remove()
        }
        userAppDataListeners = []
    }
    
    // MARK: - TeamMetaData 통신 및 관리
    var teamMetaDataListener: ListenerRegistration? = nil
    
    func getUsersForMembersIDs(memberIDs: [String], handler: @escaping (Result<[String], Error>) -> Void) {
            getAllUsers { result in
                switch result {
                case .success(let allUsers):
                    let filteredUsers = allUsers.filter { memberIDs.contains($0.id) }
                    handler(.success(filteredUsers.map({ $0.name })))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
    
    func getAllUsers(handler: @escaping (Result<[User], Error>) -> Void) {
            let db = Firestore.firestore()
            let collectionRef = db.collection("users")
            
            collectionRef.getDocuments { querySnapshot, error in
                if let error = error {
                    handler(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    handler(.failure(FirebaseError(errorMessage: "No users found")))
                    return
                }
                
                let users: [User] = documents.compactMap { document in
                    let data = document.data()
                    return User(
                        id: document.documentID,
                        email: data["email"] as? String ?? "Unknown",
                        name: data["name"] as? String ?? "Unknown"
                    )
                }
                handler(.success(users))
            }
        }
    
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
            "memberIDs": teamData.memberIDs,
            "isDisband": "false"
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
                                             hostID: document["hostID"] as? String ?? "",
                                             isDisband: document["isDisband"] as? String ?? "")
                handler(.success(teamData))
            } else {
                handler(.failure(FirebaseError(errorMessage: "Team does not exist exists")))
                return
            }
        }
    }
    
    func setUpListenerForTeamData(teamCode: String, handler: @escaping (Result<TeamMetaData, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("teamMetaData").document(teamCode)
        
        teamMetaDataListener = docRef
            .addSnapshotListener { (document, error) in
                guard let document, document.exists else {
                    if let error {
                        handler(.failure(error))
                    } else {
                        handler(.failure(FirebaseError(errorMessage: "Team does not exist exists")))
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
                let teamData = TeamMetaData(memberIDs: data["memberIDs"] as? [String] ?? [],
                                            teamName: data["teamName"] as? String ?? "",
                                            inviteCode: data["inviteCode"] as? String ?? "",
                                            hostID: data["hostID"] as? String ?? "",
                                            isDisband: data["isDisband"] as? String ?? "")
                handler(.success(teamData))
            }
    }
    
    func getTeamData(teamCode: String, handler: @escaping ((Result<TeamMetaData, Error>) -> Void)){
        let db = Firestore.firestore()
        let docRef = db.collection("teamMetaData").document(teamCode)
        
        docRef.getDocument { (document, error) in
            if let document, document.exists {
                guard let data = document.data() else {return}
                let teamData  = TeamMetaData(memberIDs: data["memberIDs"] as? [String] ?? [],
                                             teamName: data["teamName"] as? String ?? "",
                                             inviteCode: data["inviteCode"] as? String ?? "",
                                             hostID: data["hostID"] as? String ?? "",
                                             isDisband: data["isDisband"] as? String ?? "")
                handler(.success(teamData))
                return
            }
            handler(.failure(FirebaseError(errorMessage: "No team data found")))
        }
    }
    
    func getUserName(userID: String, handler: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { document, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data(),
                  let userName = data["name"] as? String else {
                handler(.failure(FirebaseError(errorMessage: "User not found or no name field")))
                return
            }
            
            handler(.success(userName))
        }
    }
    
    func getHostName(hostID: String, handler: @escaping ((Result<String, Error>) -> Void)) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(hostID)
        docRef.getDocument { (document, error) in
            if let document, document.exists {
                guard let data = document.data() else {return}
                let hostName = data["name"] as? String ?? ""
                print("data: \(hostName)")
                handler(.success(hostName))
                return
            }
        }
        handler(.failure(FirebaseError(errorMessage: "No host found")))
    }
    
    // 팀 코드 입력 후 해당 팀에서 user 삭제
    func removeUser(userID: String, teamCode: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("teamMetaData").document(teamCode)
        docRef.getDocument { (document, error) in
            if let document, document.exists {
                docRef.updateData([
                    "memberIDs": FieldValue.arrayRemove([userID])
                ])
                return
            }
        }
    }
    
    // users collection에 유저 삭제
    func deleteUserDataFromFirestore(userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                print("firebase 사용자 데이터 제거 성공")
                completion(.success(()))
            }
            
        }
    }
    
    func removeTeamListener() {
        teamMetaDataListener?.remove()
        teamMetaDataListener = nil
    }
    
    func removeAllUsersInTeam(teamCode: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("teamMetaData").document(teamCode)
        docRef.getDocument { (document, error) in
            if let document, document.exists {
                docRef.updateData([
                    "memberIDs": []
                ])
                return
            }
        }
    }
    
    func changeDisbandStatus(teamCode: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("teamMetaData").document(teamCode)
        docRef.updateData([
            "isDisband": "true"
        ])
    }
}


class FirebaseError: Error {
    let errorMessage: String
    
    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
