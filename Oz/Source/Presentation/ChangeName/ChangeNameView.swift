//
//  ChangeNameView.swift
//  Oz
//
//  Created by Jin Lee on 1/20/25.
//

import SwiftUI

struct ChangeNameView: View {
    @EnvironmentObject var router: Router
    @State var nickName: String = ""
    @State var viewModel: ChangeNameViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("닉네임 수정하기")
                .font(Font.system(size: 16, weight: .semibold))
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.lightGray2)
                    .frame(height: 32)
                TextField("변경할 닉네임을 입력하세요", text:  $nickName)
                    .textFieldStyle(.plain)
                    .padding()
                    .onSubmit {
                        if nickName != "" {
                            viewModel.changeName(to: nickName)
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
                    viewModel.changeName(to: nickName)
                    router.pop()
                }
                .customButtonStyle(backgroundColor: .systemBlue, foregroundColor: .white)
                .disabled(nickName.isEmpty)
            }
        }
        .padding(EdgeInsets(top: 50, leading: 12, bottom: 16, trailing: 12))
        .frame(width: 270, height: 200)
    }
}
