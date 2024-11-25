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
    
    @ObservedObject var viewModel = SyncRequestNotificationViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            if amSender {
                Text("수락을 기다리는 중")
                Text("10초 안에 수락을 안하면 자동으로 취소됩니다")
                Text("\(viewModel.secondsLeft)")
            } else {
                Text("\(senderName)의 도움요청")
                    .font(.headline)
                Text("5초 안에 수락을 안하면 자동으로 거절됩니다")
                Text("\(viewModel.secondsLeft)")
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
            viewModel.startTimer(){
                router.closePendingSyncWindow()
            }
        }
    }
}
