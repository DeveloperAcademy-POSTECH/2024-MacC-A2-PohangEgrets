//
//  Extension + HUDWindow.swift
//  AsyncC
//
//  Created by Jin Lee on 11/16/24.
//

import Foundation
import AppKit
import SwiftUI

extension AppDelegate {
    func makeHUDWindow() {
        hudWindow = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.nonactivatingPanel],
            backing: .buffered, defer: false
        )
    }
    
    func setUpHUDWindow() {
        makeHUDWindow()
        
        // Remove the default background color of NSPanel
        hudWindow?.isOpaque = false
        hudWindow?.backgroundColor = .clear
        
        hudWindow?.isMovable = false
        hudWindow?.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        hudWindow?.level = .floating

        hudWindow?.contentViewController = NSHostingController(
            rootView: MainStatusView(
                viewModel: MainStatusViewModel(
                    teamManagingUseCase: self.router.teamManagingUseCase,
                    appTrackingUseCase: self.router.appTrackingUseCase,
                    emoticonUseCase: self.router.emoticonUseCase)).environmentObject(self.router))
        
        // Set the CornerRadius for the View inside the NSPanel
        hudWindow?.contentView?.wantsLayer = true
        hudWindow?.contentView?.layer?.cornerRadius = 5.0
        hudWindow?.contentView?.layer?.masksToBounds = true
        
        hudWindow?.appearance = NSAppearance(named: .aqua)
    }
    
    func showHUDWindow() {
        if let hudWindow = self.hudWindow, let button = statusBarItem?.button {
            print("hi")
            if hudWindow.isVisible {
                hudWindow.orderOut(nil)
            } else {
                if let screen = button.window?.screen {
                    let statusBarFrame = button.window?.frame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
                    let xPosition = statusBarFrame.origin.x
                    let yPosition = screen.frame.maxY - statusBarFrame.height
                    
                    hudWindow.setFrameOrigin(NSPoint(x: xPosition, y: yPosition))
                }
                
                hudWindow.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    // MARK: - Show SyncRequest Notification to recipient
    func showSyncRequestNotification(sender: String) {
        if let hudWindow = hudWindow {
            let contentView = SyncRequestNotificationView(sender: sender)
            
            hudWindow.contentViewController = NSHostingController(rootView: contentView)
            hudWindow.makeKeyAndOrderFront(nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if hudWindow.isVisible {
                    hudWindow.orderOut(nil)
                }
            }
            setUpHUDWindow()
        }
    }
    
    // MARK: - Show Acknowledgment Notification
    func showAcknowledgmentNotification(sender: String) {
        if let hudWindow = hudWindow {
            // Set up the acknowledgment notification view
            let contentView = AcknowledgmentNotificationView(sender: sender)
            
            // Update HUD Content
            hudWindow.contentViewController = NSHostingController(rootView: contentView)
            hudWindow.makeKeyAndOrderFront(nil)
            
            // Auto-dismiss after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if hudWindow.isVisible {
                    hudWindow.orderOut(nil)
                }
            }
        }
    }
    
    func closeHUDWindow() {
        if let hudWindow = self.hudWindow {
            hudWindow.close()
            self.hudWindow = nil
            
        }
    }
}
