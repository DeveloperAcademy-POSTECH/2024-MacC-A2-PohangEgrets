//
//  ChangeNameView.swift
//  Oz
//
//  Created by Jin Lee on 1/20/25.
//

import SwiftUI

struct ChangeNameView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: ChangeNameViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("닉네임 수정하기")
                .font(Font.system(size: 16, weight: .semibold))
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.lightGray2)
                    .frame(height: 32)
                TextField("변경할 닉네임을 입력하세요", text:  $viewModel.nickName)
                    .textFieldStyle(.plain)
                    .padding()
                    .onSubmit {
                        if viewModel.nickName != "" {
                            viewModel.changeName(to: viewModel.nickName)
                            router.pop()
                        }
                    }
            }
            Spacer()
            HStack {
                Spacer()
                Button("취소") {
                    router.pop()
                }
                .customButtonStyle(backgroundColor: .white, foregroundColor: .darkGray2)
                
                Button("수정") {
                    viewModel.changeName(to: viewModel.nickName)
                    if viewModel.isLoginView {
                        print("LoginView에서의 접근이 아님")
                        router.push(view: .CreateOrJoinTeamView)
                    } else {
                        print("LoginView에서의 접근")
                        router.pop()
                    }
                }
                .customButtonStyle(backgroundColor: .systemBlue, foregroundColor: .white)
                .disabled(viewModel.nickName.isEmpty)
            }
        }
        .padding(EdgeInsets(top: 50, leading: 12, bottom: 16, trailing: 12))
        .frame(width: 270, height: 200)
    }
}
