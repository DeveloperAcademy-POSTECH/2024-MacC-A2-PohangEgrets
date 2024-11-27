//
//  MainStatusView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

struct MainStatusView: View {
    @EnvironmentObject var router: Router
    
    @ObservedObject var viewModel: MainStatusViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.regularMaterial)
                .frame(maxWidth: 270)

            VStack(spacing: 0){
                HStack(spacing: 0) {
                    TeamCodeView(viewModel: viewModel)
                    Spacer()
                }
                
                Divider()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                
                AppTrackingBoxView(viewModel: viewModel)
            }
            .frame(width: 270)
            .onAppear {
                viewModel.getTeamData(teamCode: viewModel.getTeamCode())
                viewModel.startShowingAppTracking()
                viewModel.setUpAllListener()
              
                // Listener that checks if the room has been disbanded
                router.teamManagingUseCase.listenToDisbandStatus(teamCode: viewModel.getTeamCode()) { isDisband in
                    if isDisband == "true" {
                        if let window = router.contentViewWindow(), window.isVisible {
                            print("이미 앱이 띄워있음")
                        } else {
                            viewModel.leaveTeam()
                            router.closeHUDWindow()
                            router.removeStatusBarItem()
                            router.setUpContentViewWindow()
                            router.closeDisbandConfirmation()
                        }
                    }
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

