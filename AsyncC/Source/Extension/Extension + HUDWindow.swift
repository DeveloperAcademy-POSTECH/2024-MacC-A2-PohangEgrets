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
        
        // Default Content (MainStatusView)
        hudWindow?.contentViewController = NSHostingController(
            rootView: MainStatusView(
                viewModel: MainStatusViewModel(
                    teamManagingUseCase: self.router.teamManagingUseCase,
                    appTrackingUseCase: self.router.appTrackingUseCase)
            )
        )
        
        // Set the CornerRadius for the View inside the NSPanel
        hudWindow?.contentView?.wantsLayer = true
        hudWindow?.contentView?.layer?.cornerRadius = 5.0
        hudWindow?.contentView?.layer?.masksToBounds = true
    }
    
    // MARK: - Show Emoticon Notification
    func showEmoticonNotification(sender: String, emoticon: String) {
        if let hudWindow = hudWindow {
            // Set up the emoticon notification view
            let contentView = EmoticonNotificationView(
                sender: sender,
                emoticon: emoticon,
                onAcknowledge: { [weak self] in
                    self?.showAcknowledgmentNotification(sender: sender)
                },
                onDismiss: { [weak self] in
                    self?.hudWindow?.orderOut(nil)
                }
            )
            
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
}
