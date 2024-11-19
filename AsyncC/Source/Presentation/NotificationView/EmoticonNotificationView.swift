//
//  EmoticonNotificationView.swift
//  AsyncC
//
//  Created by ing on 11/20/24.
//


import SwiftUI

struct EmoticonNotificationView: View {
    let sender: String
    let emoticon: String
    let onAcknowledge: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(sender) sent: \(emoticon)")
                .font(.headline)
            HStack {
                Button("Acknowledge") {
                    onAcknowledge()
                }
                Button("Dismiss") {
                    onDismiss()
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.gray.opacity(0.9))
        .cornerRadius(10)
    }
}
