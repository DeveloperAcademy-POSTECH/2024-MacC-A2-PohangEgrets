//
//  CreateOrJoinTeamButton.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/16/24.
//

import SwiftUI

struct CreateOrJoinTeamButton: View {
    @EnvironmentObject var router: Router
    
    var widthOfButton: CGFloat = 100
    var heightOfButton: CGFloat = 120
    
    var actionType: ActionToGetTeam
    
    var body: some View {
        Button {
            router.push(view: actionType.view())
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: widthOfButton, height: heightOfButton)
                    .foregroundStyle(.clear)
                VStack (spacing: 0){
                    Image(actionType.imageName())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    Text(actionType.buttonText())
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(.defaultGray)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 1, y: 1)
    }
}

extension CreateOrJoinTeamButton {
    
    enum ActionToGetTeam {
        case create
        case join
        
        func imageName() -> String {
            if self == .create {
                return "CreateTeamIcon"
            } else {
                return "JoinTeamIcon"
            }
        }
        
        func buttonText() -> String {
            if self == .create {
                return "팀 생성하기"
            } else {
                return "팀 참여하기"
            }
        }
        
        func view() -> Router.AsyncCViews {
            if self == .create {
                return .CreateTeamView
            } else {
                return .JoinTeamView
            }
        }
        
    }
}
