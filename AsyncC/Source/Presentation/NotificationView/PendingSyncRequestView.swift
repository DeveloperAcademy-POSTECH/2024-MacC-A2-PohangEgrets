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
    let recipientName: String
    var amSender: Bool
    
    @EnvironmentObject var router: Router
    
    @ObservedObject var viewModel = SyncRequestNotificationViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            if amSender {
                Text("\(recipientName)의 수락을 기다리는 중")
                    .font(Font.system(size: 16, weight: .medium))
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
            } else {
                Text("\(senderName)의 도움요청")
                    .font(Font.system(size: 16, weight: .medium))
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
            }
            Text("10초 안에 수락을 안하면 자동으로 거절됩니다")
                .font(Font.system(size: 12, weight: .light))
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
            Text("\(viewModel.secondsLeft)")
                .font(Font.system(size: 24, weight: .heavy))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            if !amSender {
                HStack {
                    Button {
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .frame(height: 24)
                                .foregroundStyle(Color.white)
                            Text("도움 수락하기")
                                .font(Font.system(size: 12, weight: .medium))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(12)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.9))
        .cornerRadius(10)
//        .frame(minWidth: 300, minHeight: 130)
        .fixedSize(horizontal: true, vertical: true)
        .onAppear {
            viewModel.router = router
            viewModel.startTimer(){
                router.closePendingSyncWindow()
            }
        }
    }
}
