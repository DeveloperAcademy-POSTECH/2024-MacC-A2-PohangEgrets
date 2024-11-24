//
//  SyncRequestNotificationView.swift
//  AsyncC
//
//  Created by ing on 11/20/24.
//


import SwiftUI

struct SyncRequestNotificationView: View {
    let sender: String
//    let onAcknowledge: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(sender) sent a request")
                .font(.headline)
            HStack {
                Button("Acknowledge") {
//                    onAcknowledge()
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.gray.opacity(0.9))
        .cornerRadius(10)
        .frame(minWidth: 173, minHeight: 130)
    }
}
