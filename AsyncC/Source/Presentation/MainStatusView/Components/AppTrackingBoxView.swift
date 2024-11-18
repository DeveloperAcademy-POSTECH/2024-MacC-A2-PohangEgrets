//
//  AppTrackingBoxView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/18/24.
//

import SwiftUI

struct AppTrackingBoxView: View {
    @ObservedObject var viewModel: MainStatusViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.appTrackings.keys.sorted(by: viewModel.customSort), id: \.self) { key in
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        if key == viewModel.hostName {
                            HostTagView()
                        }
                        
                        Text(key)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.darkGray1)
                            .padding(.bottom, 8)
                    }
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.lightGray1)
                        .stroke(
                            viewModel.containsXcode(
                                apps: viewModel.appTrackings[key] ?? []) ?
                            Color("LightBlue") : Color("LightGray2"),
                            lineWidth: 0.5
                        )
                        .shadow(color:  viewModel.containsXcode(
                            apps: viewModel.appTrackings[key] ?? []) ?
                                Color("LightBlue") : .black.opacity(0.2), radius: 4, x: 0, y: 0)
                        .frame(width: 130, height: 40)
                        .overlay {
                            HStack(spacing: 0) {
                                Spacer()
                                    .frame(width: 5)
                                ForEach(viewModel.appTrackings[key] ?? [], id:\.self) { appName in
                                    Image("\(appName)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                        .opacity(viewModel.getOpacity(appName: appName, apps: viewModel.appTrackings[key] ?? []))
                                        .padding(.leading, 5)
                                }
                                Spacer()
                            }
                        }
                        .padding(.trailing, 6)
                        .padding(.bottom, 8)
                    
                    if viewModel.getUserName() == key {
                        createButton(title: "손 들기", width: 100, height: 40, size: 16, action: {})
                            .padding(.bottom, 8)

                    } else {
                        createButton(title: "콕 찌르기", width: 48, height: 40, size: 12, action: {})
                            .padding(.trailing, 4)
                            .padding(.bottom, 8)
                        createButton(title: "손 든 거에 반응하기", width: 48, height: 40, size: 12, action: {})
                            .padding(.bottom, 8)

                    }
                }
                
                if key == viewModel.getUserName() {
                    Divider()
                        .padding(12)
                }
            }
            .padding(.horizontal, 16)
            Spacer()
        }
    }
}

extension AppTrackingBoxView {
    private func createButton(title: String, width: CGFloat, height: CGFloat, size:CGFloat, action: @escaping () -> Void) -> some View {
        return VStack {
            Button {
                action()
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.lightGray1)
                    .stroke(.lightGray2, lineWidth: 0.5)
                    .frame(width: width, height: height)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 0)
                    .overlay {
                        Text(title)
                            .font(.system(size: size, weight: .medium))
                            .lineLimit(0)
                    }
            }
            .buttonStyle(.plain)
        }
    }
}
