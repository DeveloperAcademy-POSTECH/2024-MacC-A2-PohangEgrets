//
//  TeamCodeView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/16/24.
//

import SwiftUI

struct TeamCodeView: View {
    @ObservedObject var viewModel: MainStatusViewModel
    @EnvironmentObject var router: Router
    @State var isExitAlertPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(viewModel.getTeamName())
                    .font(.system(size: 20, weight: .medium))
                    .padding(.horizontal, 16)
                    .foregroundStyle(.darkGray2)
                
                Spacer()
                
                    Button {
                        viewModel.isMenuVisible.toggle()
                        viewModel.leaveTeam()
                        router.closeHUDWindow()
                        router.removeStatusBarItem()
                        router.setUpContentViewWindow()
                        isExitAlertPresented = true
                    } label: {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.darkGray1)
                            .frame(height: 16)
                    }
                    .buttonStyle(.plain)
            }
            .padding(.top, 20)

            
            HStack(alignment: .bottom, spacing: 0){
                Text("팀 코드:")
                    .font(.system(size: 12, weight: .medium))
                    .padding(.trailing, 8)
                
                Text(viewModel.getTeamCode())
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.trailing, 2)
                
                Button {
                    viewModel.copyTeamCode()
                } label: {
                    Image(systemName: "document.on.document")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                }
                .buttonStyle(.plain)
            }
            .foregroundStyle(.gray1)
            .padding(.top, 12)
            .padding(.horizontal, 16)
        }
    }
}
