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
            VStack(alignment: .center) {
                Text("팀 참여하기")
                    .font(Font.system(size: 16, weight: .semibold))
                    .padding(EdgeInsets(top: 30, leading: 12, bottom: 0, trailing: 0))
                TextField("팀 코드를 입력하세요", text:  $teamCode)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 16, leading: 24, bottom: 31, trailing: 24))
                    .disabled(isPresented)
                HStack {
                    Spacer()
                    Button("취소") {
                        router.pop()
                    }
                    Button("참여하기") {
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
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
                Spacer()
            }
            .frame(width: 270, height: 200)
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
                            Task {
                                await viewModel.addMemberToTeam(teamCode)
                            }
                            NSApplication.shared.keyWindow?.close()
                            router.showHUDWindow()
                            
                        } label: {
                            Text("팀 참여하기")
                                .foregroundStyle(.black)
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            }
        }
        .frame(width: 270, height: 200)
    }
}
