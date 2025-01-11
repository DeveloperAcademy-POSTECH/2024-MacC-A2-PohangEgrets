//
//  Extension + ExitConfirmation.swift
//  AsyncC
//
//  Created by Jin Lee on 11/21/24.
//

import AppKit
import SwiftUI

extension AppDelegate {
    func makeAccountDeactivation() {
        accountDeactivation = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 140, height: 50),
            styleMask: [.nonactivatingPanel],
            backing: .buffered, defer: false
        )
    }
    
    func setUpAccountDeactivation() {
        makeAccountDeactivation()
        
        // Remove the default background color of NSPanel
        accountDeactivation?.isOpaque = false
        accountDeactivation?.backgroundColor = .clear
        
        accountDeactivation?.isMovable = false
        accountDeactivation?.collectionBehavior = [.stationary, .fullScreenAuxiliary]
        accountDeactivation?.level = .floating
        accountDeactivation?.contentViewController = NSHostingController(rootView: AccountDeactivation().environmentObject(self.router))
        
        // Set the CornerRadius for the View inside the NSPanel
        accountDeactivation?.contentView?.wantsLayer = true
        accountDeactivation?.contentView?.layer?.cornerRadius = 4.0
        accountDeactivation?.contentView?.layer?.masksToBounds = true
        
        accountDeactivation?.appearance = NSAppearance(named: .aqua)
    }
    
    func showAccountDeactivation() {
        if let accountDeactivation = self.accountDeactivation, let contentViewWindow = self.contentViewWindow {
            if accountDeactivation.isVisible {
                accountDeactivation.orderOut(nil)
            } else {
                let xPosition = contentViewWindow.frame.origin.x + 240
                let yPosition = contentViewWindow.frame.origin.y + 115
                
                accountDeactivation.setFrameOrigin(NSPoint(x: xPosition, y: yPosition))
                accountDeactivation.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    func closeAccountDeactivation() {
        if let accountDeactivation = self.accountDeactivation {
            accountDeactivation.close()
            self.accountDeactivation = nil
        }
    }
}
