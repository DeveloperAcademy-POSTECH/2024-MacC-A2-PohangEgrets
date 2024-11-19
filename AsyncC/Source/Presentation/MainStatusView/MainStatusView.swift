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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
                VStack(spacing: 0){
                    HStack(spacing: 0) {
                        TeamCodeView(viewModel: viewModel)
                        Spacer()
                    }
                    
                    Divider()
                        .padding(.horizontal, 12)
                    
                    HStack(spacing: 0) {
                        AppTrackingBoxView(viewModel: viewModel)
                        Spacer()
                    }
                }
            .frame(width: 270)
            .onAppear {
                print("App Tracking: \(viewModel.appTrackings)")
                viewModel.startShowingAppTracking()
                viewModel.getTeamData(teamCode: viewModel.getTeamCode())
                viewModel.checkHost()
            }
        }
    }
}

#Preview {
    var router = Router()
    MainStatusView(viewModel: MainStatusViewModel(teamManagingUseCase: router.teamManagingUseCase, appTrackingUseCase: router.appTrackingUseCase)).environmentObject(router)
}
