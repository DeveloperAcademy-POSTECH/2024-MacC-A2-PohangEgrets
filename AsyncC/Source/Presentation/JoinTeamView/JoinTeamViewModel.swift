//
//  JoinTeamViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

class JoinTeamViewModel: ObservableObject {
    let teamManagingUseCase: TeamManagingUseCase
    
    init(teamManagingUseCase: TeamManagingUseCase) {
        self.teamManagingUseCase = teamManagingUseCase
    }
    
    func addMemberToTeam(_ code: String) async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                self.teamManagingUseCase.addNewMemberToTeam(teamCode: code)
                continuation.resume()
            }
        }
    }
    
    func getDetailsOfTeam(_ code: String, handler: @escaping (Result<(teamName: String, hostName: String), Error>) -> Void)  {
        teamManagingUseCase.getTeamNameAndHostName(for: code) { result in
            handler(result)
        }
    }
}
