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
                        print("Apple 로그인 시점에서의 userID: \(userID)")
                        print("Apple 로그인 시점에서의 email: \(email ?? "Apple 로그인 시점에서의 email N/A")")

                        let fullName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")".trimmingCharacters(in: .whitespaces)
                        print("Apple 로그인 시점에서의 userName: \(fullName)")
                        
                        self.firebaseRepository.checkExistUserBy(userID: userID) { exists, name in
                            if exists {
                                if let name = name {
                                    self.saveUserIDToLocal(userID: userID)
                                    self.saveUserNameToLocal(userName: fbName ?? "N/A")
                                    print("User exists in Firebase. Fetched name: \(name)")
                                    NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
                                }
                            } else {
                                self.saveUserIDToLocal(userID: userID)
                                self.saveUserNameToLocal(userName: fbName ?? "N/A")
                                self.saveUserIDToFirebase(id: userID, email: email ?? "N/A", name: fullName.isEmpty ? "N/A" : fullName)
                                print("User not found in Firebase. Saved new user with name: \(fullName)")
                                NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
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
    func deleteFirebaseAuthUser() async -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        guard let lastSignInDate = user.metadata.lastSignInDate else { return false }
        
        let needsReauth = !lastSignInDate.isWithinPast(minutes: 5)
        let needsTokenRevocation = user.providerData.contains { $0.providerID == "apple.com" }
        do {
            if needsReauth || needsTokenRevocation {
                let signInWithApple = SignInWithApple()
                let appleIDCredential = try await signInWithApple()
                
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identify token")
                    return false
                }
                
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDCredential.debugDescription)")
                    return false
                }
                
                let nonce = randomNonceString()
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                
                if needsReauth {
                    try await user.reauthenticate(with: credential)
                }
                if needsTokenRevocation {
                    guard let authorizationCode = appleIDCredential.authorizationCode else { return false }
                    guard let authCodeString = String(data: authorizationCode, encoding: .utf8) else { return false }
                    
                    try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                }
            }
            
            // Firestore 데이터 삭제
            firebaseRepository.deleteUserDataFromFirestore(userID: user.uid) { result in
                switch result {
                case .success:
                    print("Firestore user data deleted successfully.")
                case .failure(let error):
                    print("Failed to delete Firestore user data: \(error.localizedDescription)")
                }
            }
            
            // Firebase 사용자 삭제
            user.delete { error in
                if let error = error {
                    print("Failed to delete Firebase user: \(error.localizedDescription)")
                    return
                }
                
                print("Firebase user deleted successfully.")
                
                self.localRepository.clearLocalUserData()
                self.signOut()
            }
        } catch {
            print("유저 삭제 실패")
        }
        return true
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
    
    // MARK: - 유저
    
    func getUserName(userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseRepository.getUserName(userID: userID) { result in
            switch result {
            case .success(let userName):
                completion(.success(userName))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
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

final class SignInWithApple: NSObject, ASAuthorizationControllerDelegate {
    private var continuation: CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?
    
    func callAsFunction() async throws -> ASAuthorizationAppleIDCredential {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential {
            continuation?.resume(returning: appleIDCredential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
    }
}
