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
            
            if viewModel.checkUser(key: key) {
                Toggle("", isOn: $viewModel.isToggled)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .padding(.trailing, 8)
                    .onChange(of: viewModel.isToggled) { old, new in
                        if old {
                            viewModel.startShowingAppTracking()
                            print("Started tracking")
                        } else {
                            viewModel.stopAppTracking()
                            print("S")
                        }
                    }
            }
        }
        .padding(.top, 8)
        .padding(.leading, 8)
    }
}
