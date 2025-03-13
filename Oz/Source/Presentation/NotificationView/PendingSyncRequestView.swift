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
    let sessionID: String // one-on-one sessionID
    let recipientName: String
    var amSender: Bool
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: SyncRequestNotificationViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.regularMaterial)
                .frame(maxWidth: 300)
            VStack(spacing: 10) {
                if amSender {
                    Text("\(recipientName)의 수락을 기다리는 중")
                        .font(Font.system(size: 16, weight: .medium))
                } else {
                    Text("\(senderName)의 도움요청")
                        .font(Font.system(size: 16, weight: .medium))
                }
                Text("10초 안에 수락을 안하면 자동으로 거절됩니다")
                    .font(Font.system(size: 12, weight: .light))
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
                Text("\(viewModel.secondsLeft)")
                    .font(Font.system(size: 24, weight: .heavy))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                if !amSender {
                    HStack {
                        Button {
                            viewModel.acceptSyncRequest(to: senderID, sessionID: sessionID)
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(height: 30)
                                    .foregroundStyle(Color.white)
                                Text("도움 수락하기")
                                    .font(Font.system(size: 12, weight: .medium))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
//                    .padding(12)
                }
            }
            .padding(EdgeInsets(top: 20, leading: 18, bottom: 20, trailing: 18))
        }
        .fixedSize(horizontal: true, vertical: true)
        .onAppear {
            viewModel.router = router
            viewModel.startTimer(){
                router.closePendingSyncWindow()
            }
        }
    }
}

