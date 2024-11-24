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
            }
        }
    }
}

#Preview {
    var router = Router()
    MainStatusView(viewModel: MainStatusViewModel(teamManagingUseCase: router.teamManagingUseCase, appTrackingUseCase: router.appTrackingUseCase)).environmentObject(router)
}
