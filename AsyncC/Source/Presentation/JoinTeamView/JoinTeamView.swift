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
        VStack(spacing: 16) {
            Text("팀 참여하기")
                .font(Font.system(size: 16, weight: .semibold))
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.lightGray2)
                    .frame(height: 32)
                TextField("팀 코드를 입력하세요", text:  $teamCode)
                    .textFieldStyle(.plain)
                    .padding()
                    .onSubmit {
                        if teamCode != "" {
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
                    }
            }
            Spacer()
            HStack {
                Spacer()
                Button("취소") {
                    router.pop()
                }
                .customButtonStyle(backgroundColor: .white, foregroundColor: .darkGray2)
                Button("확인") {
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
                .customButtonStyle(backgroundColor: .systemBlue, foregroundColor: .white)
                .disabled(teamCode.isEmpty)
            }
        }
        .padding(EdgeInsets(top: 50, leading: 12, bottom: 16, trailing: 12))
        .frame(width: 270, height: 200)
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("팀이 존재하지 않습니다"),
                  message: Text("팀 코드를 다시 확인해 보세요"),
                  dismissButton: .default(Text("OK")))
        }
    }
}
