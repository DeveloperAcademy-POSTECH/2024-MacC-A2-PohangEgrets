//
//  AccountManagingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

import Foundation
import AuthenticationServices

final class AccountManagingUseCase: ObservableObject {
    
    private let localRepository: LocalRepositoryProtocol
    private let firebaseRepository: FirebaseRepositoryProtocol
    
    init(localRepo: LocalRepository, firebaseRepo: FirebaseRepository) {
        self.localRepository = localRepo
        self.firebaseRepository = firebaseRepo
    }
    
    func isSignedIn() -> Bool {
        if localRepository.userID.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    private func saveUserIDToLocal(userID: String) {
        localRepository.saveUserID(userID)
    }
    
    private func saveUserNameToLocal(userName: String) {
        localRepository.saveUserName(userName)
    }
    
    private func saveUserIDToFirebase(id: String, email: String, name: String) {
        firebaseRepository.setUsers(id: id, email: email, name: name)
    }
    
    private func changeUserNameToFirebase(name: String) {
        firebaseRepository.updateUsers(id: localRepository.userID, email: nil, name: name)
    }
    
    func signInRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleAuthorization(_ result: Result<ASAuthorization, Error>, completion: (() -> Void)? = nil) {
        switch result {
        case .success(let auth):
            handleAuthorizationSuccess(auth) {
                completion?()
            }
        case .failure(let error):
            handleAuthorizationFail(with: error)
        }
    }
    
    private func handleAuthorizationSuccess(_ authResults: ASAuthorization, completion: (() -> Void)? = nil) {
        switch authResults.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userID = appleIDCredential.user
            let email = appleIDCredential.email
            let fullName = [
                appleIDCredential.fullName?.givenName,
                appleIDCredential.fullName?.familyName
            ].compactMap { $0 }
             .joined(separator: " ")
                            
            firebaseRepository.checkExistUserBy(userID: userID) { exists, name in
                if exists {
                    if let name = name {
                        self.saveUserIDToLocal(userID: userID)
                        self.saveUserNameToLocal(userName: name)
                        print("Exists in Firebase, so i fetch \(name) from Firebase")
                    }
                } else {
                    self.saveUserIDToLocal(userID: userID)
                    self.saveUserNameToLocal(userName: fullName)
                    self.saveUserIDToFirebase(id: userID, email: email ?? "N/A", name: "\(fullName.isEmpty ? "N/A" : fullName)")
                    print("Not exists in Firebase, so i save \(fullName) to Firebase")
                }
                
                // 인증 성공 후 실행할 동작 호출
                completion?()
            }
            
        default:
            break
        }
    }

    
    private func handleAuthorizationFail(with error: Error) {
        print("인증 실패: \(error.localizedDescription)")
    }
    
    func signOut() {
        self.saveUserNameToLocal(userName: "")
        self.saveUserIDToLocal(userID: "")
    }
    
    func changeUserName(userName: String) {
        saveUserNameToLocal(userName: userName)
        changeUserNameToFirebase(name: userName)
    }
    
    // MARK: - 회원 탈퇴기능 필요
    
}
