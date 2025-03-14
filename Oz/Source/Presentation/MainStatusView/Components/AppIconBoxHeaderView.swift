//
//  AppIconBoxHeaderView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/22/24.
//

import SwiftUI

struct AppIconBoxHeaderView: View {
    @ObservedObject var viewModel: MainStatusViewModel
    var key: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(key)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.black)
                .padding(.trailing, 4)
                .padding(.bottom, 4)
            
            if key == viewModel.hostName {
                HostTagView()
                    .padding(.bottom, 4)
            }
            
            Spacer()
            
            if let userID = viewModel.nameToUserId[key] {
                if key == viewModel.userName {
                    Toggle("", isOn: Binding(
                        get: { viewModel.trackingActive[userID] ?? true },
                        set: { newValue in
                            viewModel.updateUserTrackingStatus(userID: userID, isActive: newValue)
                            
                            if viewModel.checkUser(key: key) {
                                viewModel.isToggled = newValue
                            }
                        }
                    ))
                    .toggleStyle(CustomTintedToggleStyle(activeColor: .accent, inactiveColor: .gray))
                    .padding(.trailing, 8)
                    .onChange(of: viewModel.isToggled) { old, new in
                        if old {
                            viewModel.stopAppTracking()
                            viewModel.stopOtherUserAppTracking()
                            print("Stop tracking")
                        } else {
                            viewModel.startShowingAppTracking()
                            viewModel.startAppTracking()
                            viewModel.setUpAllListener()
                            
                            print("Start tracking")
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
        .padding(.leading, 8)
    }
}

extension AppIconBoxHeaderView {
    struct CustomTintedToggleStyle: ToggleStyle {
        var activeColor: Color
        var inactiveColor: Color
        
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.label
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(configuration.isOn ? activeColor : inactiveColor)
                    .frame(width: 33, height: 20)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 17, height: 17)
                            .offset(x: configuration.isOn ? 7 : -7)
                    )
                    .onTapGesture {
                        configuration.isOn.toggle()
                    }
            }
        }
    }
}

