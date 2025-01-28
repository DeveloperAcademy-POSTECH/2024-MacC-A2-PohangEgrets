//
//  LoginView.swift
//  AsyncC
//
//  Created by Jin Lee on 11/12/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.syncLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 48)
            
            SignInWithAppleButton(onRequest: { request in
                viewModel.handleSignInWithApple(request: request)
            }, onCompletion: { result in
                viewModel.handleSignInWithAppleCompletion(result: result)
            })
            .frame(width: 120, height: 28)
            .padding(.top, 28)
            
            Spacer()
        }
        .frame(width: 270, height: 200)
        .onChange(of: viewModel.shouldNavigateToChangeNameView) { shouldNavigate in
            if shouldNavigate && viewModel.isLoginView {
                router.push(view: .ChangeNameView)
            }
        }
        .onAppear {
            viewModel.isLoginView = true
        }
    }
}


