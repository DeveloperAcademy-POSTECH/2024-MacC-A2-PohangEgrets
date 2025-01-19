//
//  ChangeNameViewModel.swift
//  Oz
//
//  Created by Jin Lee on 1/20/25.
//

import SwiftUI

class ChangeNameViewModel: ObservableObject {
    let accountUseCase: AccountManagingUseCase
    
    init(accountUseCase: AccountManagingUseCase) {
        self.accountUseCase = accountUseCase
    }
    
    func changeName(to name: String) {
        accountUseCase.changeUserName(userName: name)
    }
}
