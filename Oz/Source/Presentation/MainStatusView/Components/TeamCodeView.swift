//
//  TeamCodeView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/16/24.
//

import SwiftUI

struct TeamCodeView: View {
    @ObservedObject var viewModel: MainStatusViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(viewModel.getTeamName())
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.darkGray2)
                    .lineLimit(1)
                Spacer()
                if viewModel.isTeamHost {
                    ChangeTeamNameButton()
                }
            }
            .padding(.top, 20)

            
            HStack(alignment: .bottom, spacing: 0){
                Text("팀 코드:")
                    .font(.system(size: 12, weight: .medium))
                    .padding(.trailing, 8)
                
                Text(viewModel.getTeamCode())
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.trailing, 2)
                
                Button {
                    viewModel.copyTeamCode()
                } label: {
                    Image(systemName: "document.on.document")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                }
                .buttonStyle(.plain)
            }
            .foregroundStyle(.gray1)
            .padding(.top, 12)
        }
        .padding(.horizontal, 16)
    }
    
    func ChangeTeamNameButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "pencil")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.darkGray1)
                .frame(height: 16)
        }
        .buttonStyle(.plain)
    }
}

