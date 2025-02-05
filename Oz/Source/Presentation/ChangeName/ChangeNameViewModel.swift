//
//  ChangeNameViewModel.swift
//  Oz
//
//  Created by Jin Lee on 1/20/25.
//

import SwiftUI
import Combine

class ChangeNameViewModel: ObservableObject {
    let accountUseCase: AccountManagingUseCase
    let loginViewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()

    @Published var nickName: String = ""
//    @Published var isLoginView: Bool = false
    
    init(accountUseCase: AccountManagingUseCase, loginViewModel: LoginViewModel) {
        self.accountUseCase = accountUseCase
        self.loginViewModel = loginViewModel
        
//        loginViewModel.$isLoginView
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] newValue in
//                self?.isLoginView = newValue
//            }
//            .store(in: &cancellables)
    }
    
    func changeName(to name: String) {
        accountUseCase.changeUserName(userName: name)
    }
}
