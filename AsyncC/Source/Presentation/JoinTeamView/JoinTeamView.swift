//
//  JoinTeamView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

struct JoinTeamView: View {
    @EnvironmentObject var router: Router
    @State var teamCode: String = ""
    @State var viewModel: JoinTeamViewModel
    
    @State var isPresented: Bool = false
    @State var teamDetails: (teamName: String, hostName: String) = ("", "")
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                    router.pop()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("팀 참여하기")
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 8, trailing: 0))
                Divider()
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                TextField("팀 코드를 입력하세요", text:  $teamCode)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .disabled(isPresented)
                Button("참여하기") {
                    Task {
                        await viewModel.addMemberToTeam(teamCode)
                        // Handle error when team cannot be found
                    }
                    viewModel.getDetailsOfTeam(teamCode) { result in
                        switch result {
                        case .success(let team):
                            teamDetails = (team.teamName, team.hostName)
                            isPresented = true
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        
                    }
                }
                .disabled(teamCode.isEmpty)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            }
            if isPresented {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                    VStack {
                        Text("팀명")
                            .foregroundStyle(.black)
                        Text(teamDetails.teamName)
                            .foregroundStyle(.black)
                        Text("호스트")
                            .foregroundStyle(.black)
                        Text(teamDetails.hostName)
                            .foregroundStyle(.black)
                        Button {
                            isPresented = false
                            router.push(view: .MainStatusView)
                        } label: {
                            Text("팀 참여하기")
                                .foregroundStyle(.black)
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
