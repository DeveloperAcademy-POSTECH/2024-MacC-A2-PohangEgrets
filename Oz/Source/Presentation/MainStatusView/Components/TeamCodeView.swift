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
        ZStack {
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
            CopyTeamCodeAlert()
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
    
    @ViewBuilder
    func CopyTeamCodeAlert() -> some View {
        if viewModel.isCopyTeamCode {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.regularMaterial)
                        .frame(width: 96, height: 18)
                    Text("팀 코드를 복사했습니다.")
                        .font(.system(size: 8, weight: .regular))
                }
                .offset(y:49)
                .shadow(color: .black.opacity(0.15), radius: 6)
                Spacer()
            }
        }
    }
}

