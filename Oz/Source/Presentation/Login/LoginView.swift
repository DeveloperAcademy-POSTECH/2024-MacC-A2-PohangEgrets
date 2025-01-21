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
                viewModel.accountManagingUseCase.handleSignInWithApple(request: request)
            }, onCompletion: { result in
                viewModel.accountManagingUseCase.handleSignInWithAppleCompletion(result: result)
                Auth.auth().addStateDidChangeListener { auth, user in
                    if let user = user {
                        router.push(view: .CreateOrJoinTeamView)
                    } else {
                        print("아직 로그인하지 않았습니다.")
                    }
                }
            })
            .frame(width: 120, height: 28)
            .padding(.top, 28)
            
            Spacer()
        }
        .frame(width: 270, height: 200)
    }
}


