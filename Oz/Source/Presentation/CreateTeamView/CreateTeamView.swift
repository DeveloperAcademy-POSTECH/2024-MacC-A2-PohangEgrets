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
        VStack(spacing: 16) {
            Text("팀 생성하기")
                .font(Font.system(size: 16, weight: .semibold))
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.lightGray2)
                    .frame(height: 32)
                TextField("팀 이름을 입력하세요", text:  $teamName)
                    .textFieldStyle(.plain)
                    .padding()
                    .onSubmit {
                        if teamName != "" {
                            let dispatchGroup = DispatchGroup()
                            DispatchQueue.global(qos: .userInitiated).async(group: dispatchGroup) {
                                print(viewModel.createNewTeamAndGetTeamCode(name: teamName))
                            }
                            dispatchGroup.wait()
                            
                            NSApplication.shared.keyWindow?.close()
                            router.setUpStatusBarItem()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                router.setUpHUDWindow()
                                router.showHUDWindow()
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
                Button("생성") {
                    let dispatchGroup = DispatchGroup()
                    DispatchQueue.global(qos: .userInitiated).async(group: dispatchGroup) {
                        print(viewModel.createNewTeamAndGetTeamCode(name: teamName))
                    }
                    dispatchGroup.wait()
                    
                    NSApplication.shared.keyWindow?.close()
                    router.setUpStatusBarItem()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        router.setUpHUDWindow()
                        router.showHUDWindow()
                    }
                }
                .customButtonStyle(backgroundColor: .systemBlue, foregroundColor: .white)
                .disabled(teamName.isEmpty)
            }
        }
        .padding(EdgeInsets(top: 50, leading: 12, bottom: 16, trailing: 12))
        .frame(width: 270, height: 200)
    }
}


