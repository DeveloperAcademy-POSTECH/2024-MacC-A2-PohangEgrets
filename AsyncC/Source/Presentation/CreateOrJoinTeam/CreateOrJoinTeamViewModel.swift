//
//  CreateOrJoinTeamViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

class CreateOrJoinTeamViewModel: ObservableObject {
    let teamUseCase: TeamManagingUseCase
    
    init(teamUseCase: TeamManagingUseCase) {
        self.teamUseCase = teamUseCase
    }
}
