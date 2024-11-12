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
    
    var body: some View {
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
            Button("참여하기") {
                print(teamCode)
            }
            .disabled(teamCode.isEmpty)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
