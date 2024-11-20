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
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.regularMaterial)
                        .frame(width: viewModel.checkUser(key: key) ? 243 : 140, height: 68)
                        .shadow(color: .black.opacity(0.25), radius: 6, x: 1, y: 1)
                        .overlay {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(key)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(.black)
                                        .padding(.trailing, 4)
                                    
                                    if key == viewModel.hostName {
                                        HostTagView()
                                    }
                                    Spacer()
                                    
                                    if viewModel.checkUser(key: key) {
                                        Toggle(isOn: $viewModel.isToggled) {
                                            Text("")
                                        }
                                        .toggleStyle(SwitchToggleStyle(tint: .accent)) // 토글색 안바뀜
                                        .padding(.trailing, 8)
                                        .onChange(of: viewModel.isToggled) { old, new in
                                            if new {
                                                viewModel.startShowingAppTracking()
                                            } else {
                                                viewModel.stopAppTracking()
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 4)
                                .padding(.top, 8)
                                .padding(.leading, 8)
                                
                                HStack(spacing: 0) {
                                    ForEach(viewModel.appTrackings[key] ?? [], id:\.self) { appName in
                                        Image("\(appName)")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32, height: 32)
                                            .opacity(viewModel.getOpacity(appName: appName, apps: viewModel.appTrackings[key] ?? []))
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.bottom, 8)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.trailing, viewModel.checkUser(key: key) ? 0 : 6)
                    
                    if viewModel.getUserName() != key {
                        createButton(key: "\(key)-sos", symbol: "sos", width: 27, height: 12, text: "도움요청", action: {})
                            .padding(.trailing, 4)
                        createButton(key: "\(key)-heart", symbol: "arrow.up.heart.fill", width: 18, height: 12, text: "도움제안", action: {})
                    }
                }
                .padding(.horizontal, 16)
                
                if key == viewModel.getUserName() {
                    Divider()
                        .padding(.vertical, 12)
                }
            }
            .padding(.horizontal, 16)
            Spacer()
        }
    }
}

extension AppTrackingBoxView {
    private func createButton(key: String, symbol: String, width: CGFloat, height: CGFloat, text: String, action: @escaping () -> Void) -> some View {
        return VStack(spacing: 0) {
            Spacer()
            Button {
                viewModel.toggleButtonSelection(for: key)
                action()
                viewModel.isSelectedButton.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.buttonStates[key] = false
                }
                viewModel.isSelectedButton.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.regularMaterial)
                    .frame(width: 48, height: 68)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 1, y: 1)
                    .overlay {
                        VStack(spacing: 0) {
                            Spacer()
                            Image(systemName: symbol)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(viewModel.isButtonSelected(for: key) ? .accent : .buttonDefault)
                                .frame(width: width, height: height)
                                .padding(.bottom, 11)
                            
                            Text(text)
                                .font(.system(size: 8, weight: .medium))
                                .foregroundStyle(viewModel.isButtonSelected(for: key) ? .accent : .buttonDefault)
                                .padding(.bottom, 8)
                        }
                    }
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }
}
