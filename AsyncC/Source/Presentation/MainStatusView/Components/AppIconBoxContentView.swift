//
//  AppIconBoxContentView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/22/24.
//

//import SwiftUI
//
//struct AppIconBoxContentView: View {
//    @ObservedObject var viewModel: MainStatusViewModel
//    var key: String
//    
//    var body: some View {
//        HStack(spacing: 4) {
//            
//            ForEach(viewModel.appTrackings[key] ?? [], id:\.self) { appName in
//                Image("\(appName)")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 36, height: 36)
//                    .opacity(viewModel.getOpacity(appName: appName, apps: viewModel.appTrackings[key] ?? []))
//            }
//        }
//        .padding(.leading, 12)
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}

import SwiftUI

struct AppIconBoxContentView: View {
    @ObservedObject var viewModel: MainStatusViewModel
    var key: String

    var body: some View {
        HStack(spacing: 4) {
            if let userID = viewModel.nameToUserId[key] {
                if viewModel.trackingActive[userID] ?? true || viewModel.checkUser(key: key) {
                    ForEach(viewModel.appTrackings[key] ?? [], id: \.self) { appName in
                        Image("\(appName)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .opacity(viewModel.getOpacity(appName: appName, apps: viewModel.appTrackings[key] ?? []))
                    }
                } else {
                    HStack() {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("비활성화됨")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.buttonDefault.opacity(0.5))
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
