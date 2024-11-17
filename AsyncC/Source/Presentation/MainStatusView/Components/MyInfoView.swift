//
//  MyInfoView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/17/24.
//

import SwiftUI

struct MyInfoView: View {
    @ObservedObject var viewModel: MainStatusViewModel
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            if viewModel.isTeamHost {
                RoundedRectangle(cornerRadius: 3)
                    .fill(.hostBackground)
                    .stroke(.hostStroke, style: .init(lineWidth: 1))
                    .frame(width: 32, height: 12)
                    .overlay {
                        Text("Host")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundStyle(.darkGray1)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 4)
            }
            
            Text(viewModel.getUserName())
                .font(.system(size: 12, weight: .medium))
                .padding(.top, viewModel.isTeamHost ? 0 : 8)
                .padding(.bottom, viewModel.isTeamHost ? 8 : 6)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}
