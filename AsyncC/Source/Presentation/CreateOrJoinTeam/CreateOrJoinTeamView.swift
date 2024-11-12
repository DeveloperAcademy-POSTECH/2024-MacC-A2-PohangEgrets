//
//  CreateOrJoinTeamView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

struct CreateOrJoinTeamView: View {
    @EnvironmentObject var router: Router
    var viewModel: CreateOrJoinTeamViewModel
    
    var widthOfButton: CGFloat = 100
    var heightOfButton: CGFloat = 120
    
    
    var body: some View {
            VStack {
                HStack {
                    Button {
                        router.push(view: .CreateTeamView)
                        print("Create Team")
                    } label: {
                        VStack {
                            Image("CreateTeamIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            Text("팀 생성하기")
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(maxWidth: widthOfButton, minHeight: heightOfButton)
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    Button {
                        router.push(view: .JoinTeamView)
                        print("Join Team")
                    } label: {
                        VStack {
                            Image("JoinTeamIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            Text("팀 참가하기")
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(maxWidth: widthOfButton, minHeight: heightOfButton)
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    
                }.padding()
            }
    }
}
