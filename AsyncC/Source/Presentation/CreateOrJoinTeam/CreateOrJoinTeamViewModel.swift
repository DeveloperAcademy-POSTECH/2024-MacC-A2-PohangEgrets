//
//  CreateOrJoinTeamViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI
import FirebaseAuth

class CreateOrJoinTeamViewModel: ObservableObject {
    let teamUseCase: TeamManagingUseCase
    let accountUseCase: AccountManagingUseCase
    @Published var userName: String?
    
    init(teamUseCase: TeamManagingUseCase, accountUseCase: AccountManagingUseCase) {
        self.teamUseCase = teamUseCase
        self.accountUseCase = accountUseCase
    }
    
    func fetchUserName() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("현재 유저 아이디를 받아올 수 없습니다.")
            return
        }
        
        accountUseCase.getUserName(userID: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userName):
                DispatchQueue.main.async {
                    self.userName = userName
                }
            case .failure(let error):
                print("Error fetching user name: \(error.localizedDescription)")
            }
        }
    }
}
