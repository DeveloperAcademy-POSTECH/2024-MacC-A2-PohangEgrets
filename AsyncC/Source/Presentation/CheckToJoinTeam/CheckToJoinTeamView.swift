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
        VStack(alignment: .center) {
            Text("팀명")
                .font(Font.system(size: 16, weight: .semibold))
                .padding(EdgeInsets(top: 22, leading: 0, bottom: 0, trailing: 0))
            Text(teamName)
            Text("호스트")
                .font(Font.system(size: 16, weight: .semibold))
                .padding(EdgeInsets(top: 22, leading: 0, bottom: 0, trailing: 0))
            Text(hostName)
            HStack {
                Spacer()
                Button("취소") {
                    router.pop()
                }
                Button("참여") {
                    Task {
                        await viewModel.addMemberToTeam(teamCode)
                    }
                    NSApplication.shared.keyWindow?.close()
                    router.showHUDWindow()
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 12))
            Spacer()
        }
        .frame(width: 270, height: 200)
    }
}
