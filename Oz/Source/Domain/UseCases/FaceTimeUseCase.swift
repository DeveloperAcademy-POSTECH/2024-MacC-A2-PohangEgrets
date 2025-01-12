//
//  FaceTimeUseCase.swift
//  AsyncC
//
//  Created by ing on 11/29/24.
//

import AppKit

final class FaceTimeUseCase {
    
    // Function to start a FaceTime video call
    func startFaceTimeCall(with contact: String) {
        
        // For FaceTime Video
        guard let encodedContact = contact.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "facetime://\(encodedContact)") else {
            showErrorAlert(message: "Invalid contact information.")
            return
        }
        
        // Initiate FaceTime
        if NSWorkspace.shared.open(url) {
            print("FaceTime video call initiated successfully!")
        } else {
            showErrorAlert(message: "Unable to start FaceTime.")
        }
    }
    
    // Function to show error alerts
    private func showErrorAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

