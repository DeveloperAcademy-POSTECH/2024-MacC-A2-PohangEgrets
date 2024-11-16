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
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: widthOfButton, height: heightOfButton)
                            .foregroundStyle(.clear)
                        VStack (alignment: .center){
                            Image("CreateTeamIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            Text("팀 생성하기")
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(maxWidth: widthOfButton, minHeight: heightOfButton)
                .shadow(color: .gray, radius: 3, x: 1, y: 1)
                
                Spacer()
                
                Button {
                    router.push(view: .JoinTeamView)
                    print("Join Team")
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: widthOfButton, height: heightOfButton)
                            .foregroundStyle(.clear)
                        VStack{
                            Image("JoinTeamIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            Text("팀 참가하기")
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(maxWidth: widthOfButton, minHeight: heightOfButton)
                .shadow(color: .gray, radius: 3, x: 1, y: 1)
                
            }.padding(25)
        }
        .frame(width: 270, height: 200)
    }
}
