//
//  MainStatusView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct MainStatusView: View {
    @EnvironmentObject var router: Router
    
    @StateObject var viewModel: MainStatusViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text(viewModel.getTeamName())
            HStack{
                Text("팀 코드: \(viewModel.getTeamCode())")
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.setString(viewModel.getTeamCode(), forType: .string)
                } label: {
                    Image(systemName: "document.on.document")
                }
            }
            Divider()
            ForEach(viewModel.appTrackings.keys.sorted(), id: \.self) { key in
                Text(key)
                ForEach(viewModel.appTrackings[key] ?? [], id:\.self) { appName in
                    Text(appName)
                }
            }
            Spacer()
        }
        .padding(16)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    var router = Router()
    MainStatusView(viewModel: MainStatusViewModel(teamManagingUseCase: router.teamManagingUseCase, appTrackingUseCase: router.appTrackingUseCase)).environmentObject(router)
}
