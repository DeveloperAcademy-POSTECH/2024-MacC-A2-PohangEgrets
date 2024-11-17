//
//  HostView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/16/24.
//

import SwiftUI

struct HostView: View {
    @ObservedObject var viewModel: MainStatusViewModel
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                .fill(.hostBackground)
                .stroke(.hostStroke, style: .init(lineWidth: 1))
                .frame(width: 32, height: 12)
                .overlay {
                    Text("Host")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundStyle(.lightGray1)
                }
                .padding(.top, 8)
                .padding(.bottom, 4)
            
            Text(viewModel.hostName)
                .font(.system(size: 12, weight: .medium))
                .onAppear {
                    viewModel.updateHostName(teamCode: viewModel.getTeamCode())
                }
                .padding(.bottom, 8)
        }
        .padding(.horizontal, 16)
    }
}
