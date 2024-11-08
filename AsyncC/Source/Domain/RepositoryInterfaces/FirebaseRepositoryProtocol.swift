//
//  FirebaseRepositoryProtocol.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

protocol FirebaseRepositoryProtocol {
    
    func setUserAppData(id: String,
                     appName: String,
                     epochSeconds: Int) -> Void
    
    func setUpListenersForUserAppData(userIDToIgnore: String, userIDsToTrack: [String], handler: @escaping (Result<UserAppData, Error>) -> Void)
    
    func removeListenersForUserAppData()
    
    func createNewTeamInFirestore(teamData: TeamMetaData, handler: @escaping (Result<String, Error>) -> Void)
 
    func addNewMemberToTeam(teamCode: String, userID: String, handler: @escaping (Result<TeamMetaData, Error>) -> Void)

    func setUpListenerForTeamData(teamCode: String, handler: @escaping (Result<TeamMetaData, Error>) -> Void)
    
    func getTeamData(teamCode: String, handler: @escaping ((Result<TeamMetaData, Error>) -> Void))
    
    func getHostName(hostID: String, handler: @escaping ((Result<String, Error>) -> Void))
    
    func removeUser(userID: String, teamCode: String)
    
    func removeTeamListener()
    
    func removeAllUsersInTeam(teamCode: String)
    
}
