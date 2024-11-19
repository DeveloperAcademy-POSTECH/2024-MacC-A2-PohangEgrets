//
//  AcknowledgmentNotificationView.swift
//  AsyncC
//
//  Created by ing on 11/20/24.
//


import SwiftUI

struct AcknowledgmentNotificationView: View {
    let sender: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Acknowledgment Successful!")
                .font(.headline)
            Text("You and \(sender) are now connected.")
                .font(.subheadline)
        }
        .padding()
        .background(Color.green.opacity(0.9))
        .cornerRadius(10)
    }
}
