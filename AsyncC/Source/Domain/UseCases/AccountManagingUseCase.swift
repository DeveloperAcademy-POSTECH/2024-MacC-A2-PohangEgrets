//
//  AccountManagingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

import Foundation

final class AccountManagingUseCase {
    
    private let localRepository: LocalRepository
    
    init() {
        localRepository = LocalRepository()
    }
    
    private func saveUserIDToLocal(userID: String) {
        localRepository.saveUserID(userID)
    }
    
}
