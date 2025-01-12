//
//  LoginViewModel.swift
//  AsyncC
//
//  Created by Jin Lee on 11/12/24.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    let accountManagingUseCase: AccountManagingUseCase
    
    init(accountManagingUseCase: AccountManagingUseCase) {
        self.accountManagingUseCase = accountManagingUseCase
    }
}

