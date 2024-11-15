//
//  CreateView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

struct CreateTeamView: View {
    @EnvironmentObject var router: Router
    @State var teamName: String = ""
    @State var viewModel: CreateTeamViewModel
    
    var body: some View {
        VStack {
            Button {
                router.pop()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("팀 생성하기")
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 8, trailing: 0))
            Divider()
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            TextField("팀 이름을 입력하세요", text:  $teamName)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            Button("생성하기") {
                let dispatchGroup = DispatchGroup()
                DispatchQueue.global(qos: .userInitiated).async(group: dispatchGroup) {
                    print(viewModel.createNewTeamAndGetTeamCode(name: teamName))
                }
                dispatchGroup.wait()
                NSApplication.shared.keyWindow?.close()
                router.showHUDWindow()
            }
            .disabled(teamName.isEmpty)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
        }
    }
}
