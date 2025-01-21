//
//  CreateOrJoinTeamView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

struct CreateOrJoinTeamView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: CreateOrJoinTeamViewModel
    
    var widthOfButton: CGFloat = 100
    var heightOfButton: CGFloat = 120
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(viewModel.userName ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.darkGray2)
                Spacer()

                Button {
                    router.push(view: .ChangeNameView)
                } label: {
                    Image(systemName: "pencil")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray1)
                        .frame(height: 16)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 8)
            Divider()
                .padding(.top, 13)
            HStack(spacing: 14) {
                CreateOrJoinTeamButton(actionType: .create)
                CreateOrJoinTeamButton(actionType: .join)
            }
            .padding(.top, 15)
            HStack(spacing: 8) {
                Button {
                    router.push(view: .LogoutView)
                    router.closeAccountDeactivation()
                } label: {
                    Text("로그아웃")
                        .foregroundStyle(.leaveRoomText)
                        .font(.system(size: 8, weight: .semibold))
                }
                .buttonStyle(.plain)
                Rectangle()
                    .frame(width: 0.7, height: 7)
                    .foregroundStyle(.darkGray2)
                Button {
                    router.push(view: .AccountDeleteView)
                    router.closeAccountDeactivation()
                } label: {
                    Text("탈퇴하기")
                        .foregroundStyle(.leaveRoomText)
                        .font(.system(size: 8, weight: .semibold))
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 11)
            Spacer()
        }
        .padding(EdgeInsets(top: 24, leading: 12, bottom: 10, trailing: 12))
        .frame(width: 270, height: 200)
        .onAppear {
            viewModel.fetchUserName()
        }
    }
}

