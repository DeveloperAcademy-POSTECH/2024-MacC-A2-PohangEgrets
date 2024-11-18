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
    
    @State var isAlertPresented: Bool = false
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
                HStack {
                    Spacer()
                    Button("취소") {
                        router.pop()
                    }
                    Button("참여하기") {
                        viewModel.getDetailsOfTeam(teamCode) { result in
                            switch result {
                            case .success(let team):
                                self.router.push(view: .CheckToJoinTeamView(teamCode: teamCode,
                                                                            teamName: team.teamName,
                                                                            hostName: team.hostName))
                            case .failure(let error):
                                print(error.localizedDescription)
                                isAlertPresented = true
                            }
                        }
                    }
                    .disabled(teamCode.isEmpty)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
                Spacer()
            }
            .alert(isPresented: $isAlertPresented) {
                Alert(title: Text("팀이 존재하지 않습니다"),
                      message: Text("팀 코드를 다시 확인해 보세요"),
                      dismissButton: .default(Text("OK")))
            }
            .frame(width: 270, height: 200)
        }
        .frame(width: 270, height: 200)
    }
}
