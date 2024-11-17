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
        VStack(alignment: .center) {
            Text("팀 생성하기")
                .font(Font.system(size: 16, weight: .semibold))
                .padding(EdgeInsets(top: 30, leading: 12, bottom: 0, trailing: 0))
            TextField("팀 이름을 입력하세요", text:  $teamName)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 16, leading: 24, bottom: 31, trailing: 24))
            HStack {
                Spacer()
                Button("취소") {
                    router.pop()
                }
                Button("생성") {
                    let dispatchGroup = DispatchGroup()
                    DispatchQueue.global(qos: .userInitiated).async(group: dispatchGroup) {
                        print(viewModel.createNewTeamAndGetTeamCode(name: teamName))
                    }
                    dispatchGroup.wait()
                    NSApplication.shared.keyWindow?.close()
                    router.showHUDWindow()
                }
                .disabled(teamName.isEmpty)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
                
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
            Spacer()
        }
        .frame(width: 270, height: 200)
    }
}
