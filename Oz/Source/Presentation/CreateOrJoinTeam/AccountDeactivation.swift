//
//  AccountDeactivation.swift
//  AsyncC
//
//  Created by Jin Lee on 11/26/24.
//

import SwiftUI

struct AccountDeactivation: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(.regularMaterial)         
            VStack(alignment: .leading) {
                Button {
                    router.push(view: .LogoutView)
                    router.closeAccountDeactivation()
                } label: {
                    Text("로그아웃")
                }
                .buttonStyle(.plain)
                Divider()
                    .foregroundStyle(.lightGray2)
                Button {
                    router.push(view: .AccountDeleteView)
                    router.closeAccountDeactivation()
                } label: {
                    Text("회원 탈퇴")
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .font(.system(size: 10, weight: .regular))
            .foregroundStyle(.darkGray2)
        }
        .frame(width: 140, height: 50)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

