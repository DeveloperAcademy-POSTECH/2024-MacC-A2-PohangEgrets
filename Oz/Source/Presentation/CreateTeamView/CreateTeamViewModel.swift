//
//  CreateTeamViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

class CreateTeamViewModel: ObservableObject {
    let teamManagingUseCase: TeamManagingUseCase
    
    init(teamManagingUseCase: TeamManagingUseCase) {
        self.teamManagingUseCase = teamManagingUseCase
    }
    
    func createNewTeamAndGetTeamCode(name: String) -> String{
        return teamManagingUseCase.createNewTeam(teamName: name)
    }
    
}
