//
//  LogoutView.swift
//  AsyncC
//
//  Created by Jin Lee on 11/18/24.
//

import SwiftUI

struct AccountDeleteView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            Text("SyncC")
                .font(.system(size: 16, weight: .semibold))
            Text("회원 탈퇴를 계속 진행하면\n더이상 AsyncC 를 사용할 수 없습니다")
                .multilineTextAlignment(.center)
                .font(.system(size: 12, weight: .regular))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 13)
            Spacer()
            HStack {
                Spacer()
                HStack() {
                    Button {
                        router.pop()
                    } label: {
                        Text("취소")
                    }
                    .customButtonStyle(backgroundColor: .white, foregroundColor: .darkGray2)
                    Button {
                        // MARK: - 회원 탈퇴 로직
                        Task {
                            let delet = await viewModel.deleteFirebaseAuthUser()
                            
                            if delet {
                                router.push(view: .LoginView)
                            } else {
                                router.pop()
                            }
                        }
                    } label: {
                        Text("회원탈퇴")
                            .foregroundStyle(.red)
                    }
                    .customButtonStyle(backgroundColor: .white, foregroundColor: .systemRed)
                }
            }
        }
        .padding(EdgeInsets(top: 50, leading: 12, bottom: 16, trailing: 12))
        .frame(width: 270, height: 200)
    }
}

