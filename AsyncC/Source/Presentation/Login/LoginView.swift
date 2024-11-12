//
//  LoginView.swift
//  AsyncC
//
//  Created by Jin Lee on 11/12/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var router: Router
    var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image(systemName: "heart.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 48)
            
            SignInWithAppleButton(.signIn, onRequest: viewModel.accountManagingUseCase.signInRequest, onCompletion: viewModel.accountManagingUseCase.handleAuthorization)
                .frame(width: 120, height: 28)
                .padding(.top, 28)
            
            Spacer()
        }
        .frame(width: 270, height: 200)
    }
}
