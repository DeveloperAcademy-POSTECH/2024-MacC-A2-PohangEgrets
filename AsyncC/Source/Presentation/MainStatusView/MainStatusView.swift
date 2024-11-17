//
//  MainStatusView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

// TODO: 팀코드 복사 기능
// TODO: 팀원들의 앱 데이터를 갖고오는지 확인
// TODO: 본인 앱 데이터 가지고 오는지 확인
// TODO: 현재 실행 프로그램 트래킹
// TODO: View

struct MainStatusView: View {
    @EnvironmentObject var router: Router
    
    @StateObject var viewModel: MainStatusViewModel
    
    var body: some View {
        ZStack {
            Color.pannelBackground
            
            VStack(alignment: .leading, spacing: 0){
                TeamCodeView(viewModel: viewModel)
                
                Divider()
                    .padding(.horizontal, 12)
                
                HostView(viewModel: viewModel)
                
                ForEach(viewModel.appTrackings.keys.sorted(), id: \.self) { key in
                    ForEach(viewModel.appTrackings[key] ?? [], id:\.self) { appName in
                        Text(appName)
                    }
                }
                .padding(.horizontal, 16)

                Spacer()
            }
        }
        .frame(width: 270)
        .onAppear {
            print("App Tracking: \(viewModel.appTrackings)")
            viewModel.startShowingAppTracking()
        }
    }
}

#Preview {
    var router = Router()
    MainStatusView(viewModel: MainStatusViewModel(teamManagingUseCase: router.teamManagingUseCase, appTrackingUseCase: router.appTrackingUseCase)).environmentObject(router)
}
