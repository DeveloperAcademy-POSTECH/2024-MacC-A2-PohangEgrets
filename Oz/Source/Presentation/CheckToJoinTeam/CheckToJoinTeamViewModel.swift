//
//  CheckToJoinTeamViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/18/24.
//


import SwiftUI

class CheckToJoinTeamViewModel: ObservableObject {
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
}

