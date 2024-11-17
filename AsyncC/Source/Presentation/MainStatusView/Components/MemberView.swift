//
//  MemberView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/16/24.
//

import SwiftUI

struct MemberView: View {
    @ObservedObject var viewModel: MainStatusViewModel
    
    var body: some View {
        ForEach(viewModel.teamMembers, id: \.self) { member in
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
                        .padding(.top, 12)
                        .padding(.bottom, 4)
                }
                
                Text(member)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.top, viewModel.isTeamHost ? 0 : 10)
                    .padding(.bottom, viewModel.isTeamHost ? 8 : 6)
            }
        }
        .padding(.horizontal, 16)
    }
}
