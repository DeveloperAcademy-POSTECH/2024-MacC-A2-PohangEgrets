//
//  CreateOrJoinTeamView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

struct CreateOrJoinTeamView: View {
    @EnvironmentObject var router: Router
    var viewModel: CreateOrJoinTeamViewModel
    
    var widthOfButton: CGFloat = 100
    var heightOfButton: CGFloat = 120
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("\(router.localRepository.userName)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.darkGray2)
                Spacer()
                Text("로그아웃")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.logOutGray)
                    .onTapGesture {                        
                        router.push(view: .LogoutView)
                    }
            }
            .padding(.horizontal, 8)
            Divider()
                .padding(.top, 13)
            HStack(spacing: 14) {
                CreateOrJoinTeamButton(actionType: .create)
                CreateOrJoinTeamButton(actionType: .join)
            }
            .padding(.top, 15)
            Spacer()
        }
        .padding(EdgeInsets(top: 24, leading: 12, bottom: 19, trailing: 12))
        .frame(width: 270, height: 200)
    }
}
