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
                        ZStack {
                            Rectangle()
                                .frame(width: widthOfButton, height: heightOfButton)
                                .foregroundStyle(.clear)
                            VStack(spacing: 0) {
                                Image("CreateTeamIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                Text("팀 생성하기")
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    Button {
                        router.push(view: .JoinTeamView)
                        print("Join Team")
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: widthOfButton, height: heightOfButton)
                                .foregroundStyle(.clear)
                            VStack(spacing: 0) {
                                Image("JoinTeamIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                Text("팀 참가하기")
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    
                }.padding()
            }
            .frame(width: 270, height: 200)
    }
}
