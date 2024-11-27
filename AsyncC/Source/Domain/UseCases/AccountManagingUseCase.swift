//
//  AccountManagingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore

final class AccountManagingUseCase: NSObject {
    fileprivate var currentNonce: String?
    
    private let localRepository: LocalRepositoryProtocol
    private let firebaseRepository: FirebaseRepositoryProtocol
    
    init(localRepo: LocalRepository, firebaseRepo: FirebaseRepository) {
        self.localRepository = localRepo
        self.firebaseRepository = firebaseRepo
    }
    
    // MARK: - 로그인
    func handleSignInWithApple(request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleSignInWithAppleCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                
                guard let appleIDToken = appleIDCredential.identityToken,
                      let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to fetch identity token")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                
                FirebaseAuth.Auth.auth().signIn(with: credential) { authDataResult, error in
                    if let error = error {
                        print("Error during Firebase Sign-In: \(error.localizedDescription)")
                        return
                    }
                    
                    let firebaseUser = Auth.auth().currentUser
                    let fbName = firebaseUser?.displayName
                    
                    if let user = authDataResult?.user {
                        let userID = user.uid
                        let email = user.email
                        let fullName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")".trimmingCharacters(in: .whitespaces)
                        
                        self.firebaseRepository.checkExistUserBy(userID: userID) { exists, name in
                            if exists {
                                if let name = name {
                                    self.saveUserIDToLocal(userID: userID)
                                    self.saveUserNameToLocal(userName: fbName ?? "N/A")
                                    print("User exists in Firebase. Fetched name: \(name)")
                                }
                            } else {
                                self.saveUserIDToLocal(userID: userID)
                                self.saveUserNameToLocal(userName: fbName ?? "N/A")
                                self.saveUserIDToFirebase(id: userID, email: email ?? "N/A", name: fullName.isEmpty ? "N/A" : fullName)
                                print("User not found in Firebase. Saved new user with name: \(fullName)")
                            }
                        }
                    }
                }
            }
        case .failure(let error):
            print("Sign in with Apple failed: \(error.localizedDescription)")
        }
    }
    
    func isSignedIn() -> Bool {
        if localRepository.userID.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - 로그아웃
    func signOut() {
        let firebaseAuth = Auth.auth()
        print(firebaseAuth.currentUser?.uid)
        do {
            try firebaseAuth.signOut()
            self.saveUserNameToLocal(userName: "")
            self.saveUserIDToLocal(userID: "")
        } catch {
            print("로그아웃 실패")
        }
    }
    
    // MARK: - 회원탈퇴
    // 파이어베이스 Auth 회원탈퇴: O
    // 애플 API 회원탈퇴: X
    // Apple로 로그인으로 사용자를 생성할 때 Firebase는 사용자 토큰을 저장하지 않으므로 토큰을 취소하고 계정을 삭제하기 전에 사용자에게 다시 로그인하도록 요청해야 합니다.: X
    
    // 애플 API 회원탈퇴 시 다시 값 받아오는게 필요하면
    func reauthenticateForApple(completion: @escaping (String) -> Void) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.performRequests()
        
        // Apple API의 인증 성공 핸들러에서 `authorizationCode`를 가져옵니다.
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
               let authorizationCode = appleIDCredential.authorizationCode,
               let authCodeString = String(data: authorizationCode, encoding: .utf8) {
                completion(authCodeString)
            } else {
                print("Failed to retrieve authorization code.")
            }
        }
    }
    
    func deleteFirebaseAuthUser() {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }
        
        print("Deleting user with userID: \(user.uid)")
        
        // Firestore 데이터 삭제
        firebaseRepository.deleteUserDataFromFirestore(userID: user.uid) { result in
            switch result {
            case .success:
                print("Firestore user data deleted successfully.")
            case .failure(let error):
                print("Failed to delete Firestore user data: \(error.localizedDescription)")
                self.signOut()
            }
        }
        
        // Firebase 사용자 삭제
        user.delete { error in
            if let error = error {
                print("Failed to delete Firebase user: \(error.localizedDescription)")
                return
            }
            
            print("Firebase user deleted successfully.")
            
//            // Apple API: 토큰 취소
//            self.reauthenticateForApple { authCodeString in
//                Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
//            }
        }
    }

    // MARK: - 사용자 로컬 데이터 저장
    private func saveUserIDToLocal(userID: String) {
        localRepository.saveUserID(userID)
    }
    
    private func saveUserNameToLocal(userName: String) {
        localRepository.saveUserName(userName)
    }
    
    private func saveUserIDToFirebase(id: String, email: String, name: String) {
        firebaseRepository.setUsers(id: id, email: email, name: name)
    }
    
    // MARK: - 유저 이름 변경
    private func changeUserNameToFirebase(name: String) {
        firebaseRepository.updateUsers(id: localRepository.userID, email: nil, name: name)
    }
    
    func changeUserName(userName: String) {
        saveUserNameToLocal(userName: userName)
        changeUserNameToFirebase(name: userName)
    }
    
    // MARK: - Util
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                
                if errorCode != errSecSuccess {
                    fatalError("Nonce 생성 실패. OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

// MARK: - delegate
extension AccountManagingUseCase: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        handleSignInWithAppleCompletion(result: .success(authorization))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}


@available(iOS 13.0, *)
extension AccountManagingUseCase: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return NSApplication.shared.keyWindow ?? NSApplication.shared.windows.first!
    }
}
