//
//  LoginViewModel.swift
//  AsyncC
//
//  Created by Jin Lee on 11/12/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import Combine

class LoginViewModel: ObservableObject {
    private let accountManagingUseCase: AccountManagingUseCase
    
    @Published var shouldNavigateToChangeNameView: Bool = true
    
    init(accountManagingUseCase: AccountManagingUseCase) {
        self.accountManagingUseCase = accountManagingUseCase
        self.observeAuthStateChanges()
        self.saveFirstSignIn(firstSignIn: false)
    }
    
    public func handleSignInWithApple(request: ASAuthorizationAppleIDRequest) {
        accountManagingUseCase.handleSignInWithApple(request: request)
    }
    
    public func handleSignInWithAppleCompletion(result: Result<ASAuthorization, any Error>) {
        accountManagingUseCase.handleSignInWithAppleCompletion(result: result)
    }
    
    private func observeAuthStateChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if user != nil {
                self.shouldNavigateToChangeNameView = true
            } else {
                self.shouldNavigateToChangeNameView = false
            }
        }
    }
    
    public func signOut() {
        accountManagingUseCase.signOut()
    }
    
    public func deleteFirebaseAuthUser() async -> Bool {
        return await accountManagingUseCase.deleteFirebaseAuthUser()
    }
    
    public func getFirstSignIn() -> Bool {
        return accountManagingUseCase.getFirstSignIn()
    }
    
    public func saveFirstSignIn(firstSignIn: Bool) {
        return accountManagingUseCase.saveFirstSignIn(firstSignIn: firstSignIn)
    }
}

