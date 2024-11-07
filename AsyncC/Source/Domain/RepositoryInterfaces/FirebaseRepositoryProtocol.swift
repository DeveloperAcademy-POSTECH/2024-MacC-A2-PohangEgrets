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
    
    func setUpListenersForUserAppData(userIDs: [String], handler: @escaping (Result<UserAppData, Error>) -> Void)
    
    func createNewTeamInFirestore(teamData: TeamMetaData, handler: @escaping (Result<String, Error>) -> Void)
 
    func addNewMemberToTeam(teamCode: String, userID: String, handler: @escaping (Result<TeamMetaData, Error>) -> Void)
    
}
