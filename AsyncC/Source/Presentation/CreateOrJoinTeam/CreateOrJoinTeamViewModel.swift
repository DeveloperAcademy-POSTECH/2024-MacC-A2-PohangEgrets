//
//  CreateOrJoinTeamViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

class CreateOrJoinTeamViewModel: ObservableObject {
    let teamUseCase: TeamManagingUseCase
    let accountUseCase: AccountManagingUseCase
    init(teamUseCase: TeamManagingUseCase, accountUseCase: AccountManagingUseCase) {
        self.teamUseCase = teamUseCase
        self.accountUseCase = accountUseCase
    }
}
