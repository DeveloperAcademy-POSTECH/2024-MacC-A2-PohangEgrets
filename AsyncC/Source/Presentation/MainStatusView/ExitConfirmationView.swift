//
//  Untitled.swift
//  AsyncC
//
//  Created by Jin Lee on 11/21/24.
//

import SwiftUI

struct ExitConfirmationView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: MainStatusViewModel
    
    var body: some View {
        Button {
            viewModel.leaveTeam()
            router.closeHUDWindow()
            router.removeStatusBarItem()
            router.setUpContentViewWindow()
            router.closeExitConfirmation()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.regularMaterial)
                HStack(spacing: 0) {
                    Text("팀 해체하기")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundStyle(.darkGray2)
                        .padding(.leading, 12)
                    Spacer()
                }
            }
        }
        .frame(width: 140, height:  25)
        .customButtonStyle(backgroundColor: .clear, foregroundColor: .darkGray2)
    }
}
