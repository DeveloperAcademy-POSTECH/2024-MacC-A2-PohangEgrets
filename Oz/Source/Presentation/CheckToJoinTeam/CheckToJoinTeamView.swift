//
//  CheckToJoinTeamView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/18/24.
//

import SwiftUI

struct CheckToJoinTeamView: View {
    @EnvironmentObject var router: Router
    
    var viewModel: CheckToJoinTeamViewModel
    
    var teamCode: String
    var teamName: String
    var hostName: String
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 9) {
                Text("팀명")
                    .font(Font.system(size: 16, weight: .semibold))
                Text(teamName)
            }
            VStack(spacing: 9) {
                Text("호스트")
                    .font(Font.system(size: 16, weight: .semibold))
                Text(hostName)
            }
            Spacer()
            HStack {
                Spacer()
                Button("취소") {
                    router.pop()
                }
                .customButtonStyle(backgroundColor: .white, foregroundColor: .darkGray2)
                Button("참여") {
                    Task {
                        await viewModel.addMemberToTeam(teamCode)
                    }
                    NSApplication.shared.keyWindow?.close()
                    router.setUpStatusBarItem()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        router.setUpHUDWindow()
                        router.showHUDWindow()
                    }
                }
                .customButtonStyle(backgroundColor: .systemBlue, foregroundColor: .white)
            }
        }
        .padding(EdgeInsets(top: 32, leading: 12, bottom: 16, trailing: 12))
        .frame(width: 270, height: 200)
    }
}

