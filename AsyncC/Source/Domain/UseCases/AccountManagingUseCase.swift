//
//  AccountManagingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

import Foundation
import AuthenticationServices

final class AccountManagingUseCase {
    
    private let localRepository: LocalRepository
    private let firebaseRepository: FirebaseRepository
    
    init(localRepo: LocalRepository, firebaseRepo: FirebaseRepository) {
        self.localRepository = localRepo
        self.firebaseRepository = firebaseRepo
    }
    
    private func saveUserIDToLocal(userID: String) {
        localRepository.saveUserID(userID)
    }
    
    private func saveUserIDToFirebase(id: String, email: String, name: String) {
        firebaseRepository.setUsers(id: id, email: email, name: name)
    }
    
    func signInRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleAuthorization(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            handleAuthorizationSuccess(auth)
        case .failure(let error):
            handleAuthorizationFail(with: error)
        }
    }
    
    private func handleAuthorizationSuccess(_ authResults: ASAuthorization) {
        switch authResults.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userID = appleIDCredential.user
            let email = appleIDCredential.email
            let fullName = [
                appleIDCredential.fullName?.givenName,  // 이름
                appleIDCredential.fullName?.familyName  // 성
            ].compactMap { $0 } // nil을 제거
             .joined(separator: " ") // 공백으로 연결
            
            saveUserIDToLocal(userID: userID)
            saveUserIDToFirebase(id: userID, email: email ?? "N/A", name: "\(fullName.isEmpty ? "N/A" : fullName)")
            
        default:
            break
        }
    }
    
    private func handleAuthorizationFail(with error: Error) {
        print("인증 실패: \(error.localizedDescription)")
    }
}
