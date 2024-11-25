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
            ForEach(viewModel.appTrackings.keys.sorted(by: viewModel.customSort), id: \.self) { (key: String) in
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.ultraThinMaterial)
                        .strokeBorder(.buttonStroke, lineWidth: 0.5)
                        .frame(width: viewModel.checkUser(key: key) ? 243 : 140, height: 68)
                        .overlay {
                            VStack(spacing: 0) {
                                AppIconBoxHeaderView(viewModel: viewModel, key: key)
                                AppIconBoxContentView(viewModel: viewModel, key: key)
                            }
                        }
                        .padding(.trailing, 4)
                    
                    if viewModel.getUserName() != key {
                        SyncButton(viewModel: viewModel, key: key, action: {
                        if let userID = viewModel.userNameAndID[key] {
                            viewModel.emoticonUseCase.requestForSync(receiver: userID)
                            }
                        })

                    }
                }
                .padding(.vertical, 4.5)
                .padding(.horizontal, 16)
                
                if key == viewModel.getUserName() {
                    Rectangle()
                        .overlay {
                            Divider()
                        }
                        .padding(.vertical, 12)
                }
            }
            .padding(.horizontal, 16)
            Spacer()
        }
    }
}
