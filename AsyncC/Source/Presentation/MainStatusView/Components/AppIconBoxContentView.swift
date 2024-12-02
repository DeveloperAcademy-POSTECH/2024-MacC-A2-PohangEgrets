//
//  AppIconBoxContentView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/22/24.
//

import SwiftUI

struct AppIconBoxContentView: View {
    @ObservedObject var viewModel: MainStatusViewModel
    var key: String

    var body: some View {
        HStack(spacing: 4) {
            if let userID = viewModel.nameToUserId[key] {
                if viewModel.trackingActive[userID] ?? true || viewModel.checkUser(key: key) {
                    ForEach(viewModel.appTrackings[key] ?? [], id: \.self) { appName in
                        if let nsImage = NSImage(named: appName) {
                            Image(nsImage: nsImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                                .opacity(viewModel.getOpacity(appName: appName, apps: viewModel.appTrackings[key] ?? []))
                        } else {
                            Image("etc")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                                .opacity(viewModel.getOpacity(appName: appName, apps: viewModel.appTrackings[key] ?? []))
                        }
                    }
                } else {
                    VStack() {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("비활성화됨")
                                .font(.system(size: 16, weight: .medium))
                                .frame(width: 78)
                                .foregroundColor(.buttonDefault.opacity(0.5))
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(width: 78, height: 36)
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
