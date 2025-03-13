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
                            ZStack {
                                Image(nsImage: nsImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 36, height: 36)
                                    .opacity(viewModel.getOpacity(appName: appName, apps: viewModel.appTrackings[key] ?? []))
                                    .onHover { hovering in
                                        viewModel.isAppIconHover = hovering
                                    }
                                if viewModel.isAppIconHover {
                                    Text("\(appName)")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundStyle(.black)
                                        .frame(width: 36, height: 36)
                                        .allowsHitTesting(!viewModel.isAppIconHover)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .offset(x: 0.5, y: -12.5)
                                    Text("\(appName)")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundStyle(.white)
                                        .frame(width: 36, height: 36)
                                        .allowsHitTesting(!viewModel.isAppIconHover)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .offset(y: -13)
                                }
                            }
                        } else {
                            ZStack {
                                Image("etc")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 36, height: 36)
                                    .opacity(viewModel.getOpacity(appName: appName, apps: viewModel.appTrackings[key] ?? []))
                                    .onHover { hovering in
                                        viewModel.isAppIconHover = hovering
                                    }
                                if viewModel.isAppIconHover {
                                    Text("\(appName)")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundStyle(.black)
                                        .frame(width: 36, height: 36)
                                        .allowsHitTesting(!viewModel.isAppIconHover)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .offset(x: 0.5, y: -12.5)
                                    Text("\(appName)")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundStyle(.white)
                                        .frame(width: 36, height: 36)
                                        .allowsHitTesting(!viewModel.isAppIconHover)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .offset(y: -13)
                                }
                            }
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

