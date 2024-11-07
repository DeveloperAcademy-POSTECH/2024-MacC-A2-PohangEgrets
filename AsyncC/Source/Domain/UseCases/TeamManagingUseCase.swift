//
//  TeamManagingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/7/24.
//

import Foundation

final class TeamManagingUseCase {
    
    private let firebaseRepository: FirebaseRepository
    private let localRepository: LocalRepository
    
    init() {
        firebaseRepository = FirebaseRepository()
        localRepository = LocalRepository()
    }
    
    func createNewTeam(teamName: String) -> String {
        let teamCode = generateTeamCode()
        let hostID = localRepository.getUserID()
        let teamMetaData = TeamMetaData(memberIDs: [hostID], teamName: teamName, inviteCode: teamCode, hostID: hostID)
        
        firebaseRepository.createNewTeamInFirestore(teamData: teamMetaData) { result in
            switch result {
            case .success(var message):
                print(message)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return teamCode
    }
    
    private func generateTeamCode() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyz0123456789"
        
        return String((0..<6).compactMap { _ in characters.randomElement() })
    }
}
