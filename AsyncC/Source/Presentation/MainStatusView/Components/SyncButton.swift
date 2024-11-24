//
//  SyncButton.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/22/24.
//

import SwiftUI

struct SyncButton: View {
    @ObservedObject var viewModel: MainStatusViewModel
    var key: String
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                viewModel.toggleButtonSelection(for: key)
                action()
                viewModel.isSelectedButton.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    viewModel.buttonStates[key] = false
                }
                viewModel.isSelectedButton.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .frame(width: 99, height: 69)
                    .shadow(color: .black.opacity(0.25), radius: 3, x: 1, y: 1)
                    .overlay {
                        VStack(spacing: 12) {
                            Spacer()
                            Image(systemName: "arrow.2.squarepath")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(viewModel.isButtonSelected(for: key) ? .accent : .buttonDefault)
                                .frame(width: 30, height: 12)
                            
                            Text("Sync On")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(viewModel.isButtonSelected(for: key) ? .accent : .buttonDefault)
                                .padding(.bottom, 12)
                        }
                    }
            }
            .buttonStyle(.plain)
        }
    }
}
