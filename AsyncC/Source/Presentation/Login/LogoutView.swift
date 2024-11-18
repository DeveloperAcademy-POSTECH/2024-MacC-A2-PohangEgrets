//
//  LogoutView.swift
//  AsyncC
//
//  Created by Jin Lee on 11/18/24.
//

import SwiftUI

struct LogoutView: View {
    @EnvironmentObject var router: Router    
    
    var body: some View {
        VStack(spacing: 27) {
            Text("SyncC")
                .font(.system(size: 16, weight: .semibold))
            Text("로그아웃을 계속 진행하시겠습니까?")
                .font(.system(size: 12, weight: .regular))
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
                        router.accountManagingUseCase.signOut()
                        router.push(view: .LoginView)
                    } label: {
                        Text("로그아웃")
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
