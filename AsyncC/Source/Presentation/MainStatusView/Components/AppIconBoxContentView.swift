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
            ForEach(viewModel.appTrackings[key] ?? [], id:\.self) { appName in
                Image("\(appName)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .opacity(viewModel.getOpacity(appName: appName, apps: viewModel.appTrackings[key] ?? []))
            }
        }
        .padding(.leading, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
