//
//  SyncRequestNotificationView.swift
//  AsyncC
//
//  Created by ing on 11/20/24.
//


import SwiftUI

struct PendingSyncRequestView: View {
    let senderName: String
    let senderID: String
    var amSender: Bool
    
    @EnvironmentObject var router: Router
    
    @ObservedObject var viewModel: SyncRequestNotificationViewModel

    var body: some View {
        VStack(spacing: 10) {
            if amSender {
                Text("Waiting for acknowledgement")
            } else {
                Text("\(senderName) sent a request")
                    .font(.headline)
                HStack {
                    Button("Acknowledge") {
                        viewModel.acceptSyncRequest(to: senderID)
                    }
                }
                .padding(.top, 10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.9))
        .cornerRadius(10)
        .frame(minWidth: 173, minHeight: 130)
        .onAppear {
            viewModel.router = router
        }
    }
}
