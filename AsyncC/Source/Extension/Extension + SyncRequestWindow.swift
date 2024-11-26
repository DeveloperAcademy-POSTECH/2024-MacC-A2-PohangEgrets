//
//  Extension + SyncRequestWindow.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/25/24.
//

import Foundation
import AppKit
import SwiftUI

extension AppDelegate {
    private func makePendingSyncWindow() {
        pendingSyncWindow = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.nonactivatingPanel],
            backing: .buffered, defer: false
        )
    }
    
    func setUpPendingSyncWindow(senderName: String,
                                senderID: String,
                                recipientName: String,
                                isSender: Bool) {
        makePendingSyncWindow()
        
        // Remove the default background color of NSPanel
        pendingSyncWindow?.isOpaque = false
        pendingSyncWindow?.backgroundColor = .clear
        
        pendingSyncWindow?.isMovable = false
        pendingSyncWindow?.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        pendingSyncWindow?.level = .floating
        
        pendingSyncWindow?.contentViewController = NSHostingController(
            rootView: PendingSyncRequestView(senderName: senderName,
                                             senderID: senderID,
                                             recipientName: recipientName,
                                             amSender: isSender,
                                             viewModel: SyncRequestNotificationViewModel(teamManagingUseCase: self.router.teamManagingUseCase, syncUseCase: self.router.syncUseCase, sharePlayUseCase: self.router.sharePlayUseCase)
                                            ).environmentObject(self.router)
        )
        
        // Set the CornerRadius for the View inside the NSPanel
        pendingSyncWindow?.contentView?.wantsLayer = true
        pendingSyncWindow?.contentView?.layer?.cornerRadius = 8.0
        pendingSyncWindow?.contentView?.layer?.masksToBounds = true
        
        pendingSyncWindow?.appearance = NSAppearance(named: .aqua)
    }
    
    func showPendingSyncWindow() {
        if let pendingSyncWindow = self.pendingSyncWindow, let button = statusBarItem?.button {
            print("showing Sync window")
            if pendingSyncWindow.isVisible {
                pendingSyncWindow.orderOut(nil)
            } else {
                if let screen = button.window?.screen {
                    let statusBarFrame = button.window?.frame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
                    let xPosition = statusBarFrame.origin.x
                    let yPosition = screen.frame.maxY - statusBarFrame.height
                    
                    pendingSyncWindow.setFrameOrigin(NSPoint(x: xPosition, y: yPosition))
                }
                
                pendingSyncWindow.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    func closePendingSyncWindow() {
        if let pendingSyncWindow = self.pendingSyncWindow {
            pendingSyncWindow.close()
            self.pendingSyncWindow = nil
            
        }
    }
}
