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
    @Published var userName: String? {
        didSet {
            print("CreateOrJoinTeam.userName: \(userName ?? "N/A")")
        }
    }
    
    init(teamUseCase: TeamManagingUseCase, accountUseCase: AccountManagingUseCase) {
        self.teamUseCase = teamUseCase
        self.accountUseCase = accountUseCase
        
        NotificationCenter.default.addObserver(self, selector: #selector(onAuthStateChanged), name: .AuthStateDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AuthStateDidChange, object: nil)
    }
    
    @objc private func onAuthStateChanged() {
            print("Auth state changed, fetching user name...")
            self.fetchUserName()
        }
    
    func fetchUserName() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let userID = Auth.auth().currentUser?.uid else {
                print("CreateOrJoinTeamViewModel: 현재 유저 아이디를 받아올 수 없습니다.")
                return
            }
            
            self.accountUseCase.getUserName(userID: userID) { [weak self] result in
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
}
