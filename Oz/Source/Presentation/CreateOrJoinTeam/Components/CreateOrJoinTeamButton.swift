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
    var heightOfButton: CGFloat = 105
    
    var actionType: ActionToGetTeam
    
    var body: some View {
        Button {
            router.push(view: actionType.view())
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: widthOfButton, height: heightOfButton)
                    .foregroundStyle(.clear)
                ZStack {
                    Image(systemName: actionType.imageName())
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.darkGray2)
                        .frame(width: 60)
                    VStack {
                        Spacer()
                        Text(actionType.buttonText())
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.darkGray2)
                            .padding(.bottom, 15)
                    }
                }
                .offset(y: -6)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(.defaultGray)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.15), radius: 2, x: 1, y: 1)
    }
}

extension CreateOrJoinTeamButton {
    
    enum ActionToGetTeam {
        case create
        case join
        
        func imageName() -> String {
            if self == .create {
                return "person.3.fill"
            } else {
                return "person.2.badge.plus.fill"
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

