//
//  FirebaseRepositoryProtocol.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

protocol FirebaseRepositoryProtocol {
    func setTrackingActive(id: String, isActive: Bool)
    
    func setUpListenerForTrackingActive(for userID: String, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func setUserAppData(id: String,
                     appName: String,
                     epochSeconds: Int) -> Void
    
    func setUpListenersForUserAppData(userIDToIgnore: String, userIDsToTrack: [String], handler: @escaping (Result<UserAppData, Error>) -> Void)
    
    func removeListenersForUserAppData()
    
    func createNewTeamInFirestore(teamData: TeamMetaData, handler: @escaping (Result<String, Error>) -> Void)
 
    func addNewMemberToTeam(teamCode: String, userID: String, handler: @escaping (Result<TeamMetaData, Error>) -> Void)

    func setUpListenerForTeamData(teamCode: String, handler: @escaping (Result<TeamMetaData, Error>) -> Void)
    
    func getTeamData(teamCode: String, handler: @escaping ((Result<TeamMetaData, Error>) -> Void))
    
    func getUsersForMembersIDs(memberIDs: [String], handler: @escaping (Result<[String], Error>) -> Void)
    
    func getAllUsers(handler: @escaping (Result<[User], Error>) -> Void)
    
    func getUserName(userID: String, handler: @escaping (Result<String, Error>) -> Void)

    func getHostName(hostID: String, handler: @escaping ((Result<String, Error>) -> Void))
    
    func removeUser(userID: String, teamCode: String)
    
    func removeTeamListener()
    
    func removeAllUsersInTeam(teamCode: String)

    func setUsers(id: String,
                  email: String,
                  name: String) -> Void
    
    func updateUsers(id: String,
                     email: String?,
                     name: String?) -> Void
    
    func checkExistUserBy(userID: String, completion: @escaping (Bool, String?) -> Void)
    
    func sendEmoticon(sender: String,
                      emoticon: String,
                      receiver: String) -> Void
    
    func setUpListenerForEmoticons(userID: String, handler: @escaping (Result<Emoticon, any Error>) -> Void)

    func changeDisbandStatus(teamCode: String)
}
