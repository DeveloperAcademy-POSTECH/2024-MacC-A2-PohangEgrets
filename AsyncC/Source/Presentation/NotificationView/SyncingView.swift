//
//  AcknowledgmentNotificationView.swift
//  AsyncC
//
//  Created by ing on 11/20/24.
//


import SwiftUI

struct SyncingView: View {
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Syncing")
                .font(.headline)
        }
        .padding()
        .background(Color.green.opacity(0.9))
        .cornerRadius(10)
        .frame(minWidth: 173, minHeight: 130)
    }
}
