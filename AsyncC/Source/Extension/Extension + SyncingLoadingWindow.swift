//
//  Extension + SyncingLoadingWindow.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/25/24.
//

import Foundation
import AppKit
import SwiftUI

extension AppDelegate {
    private func makeSyncingLoadingWindow() {
        syncingLoadingWindow = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.nonactivatingPanel],
            backing: .buffered, defer: false
        )
    }
    
    func setUpSyncingLoadingWindow() {
        makeSyncingLoadingWindow()
        
        // Remove the default background color of NSPanel
        syncingLoadingWindow?.isOpaque = false
        syncingLoadingWindow?.backgroundColor = .clear
        
        syncingLoadingWindow?.isMovable = false
        syncingLoadingWindow?.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        syncingLoadingWindow?.level = .floating
        
        syncingLoadingWindow?.contentViewController = NSHostingController(
            rootView: SyncingView().environmentObject(self.router)
        )
        
        // Set the CornerRadius for the View inside the NSPanel
        syncingLoadingWindow?.contentView?.wantsLayer = true
        syncingLoadingWindow?.contentView?.layer?.cornerRadius = 5.0
        syncingLoadingWindow?.contentView?.layer?.masksToBounds = true
        
        syncingLoadingWindow?.appearance = NSAppearance(named: .aqua)
    }
    
    func showSyncingLoadingWindow() {
        if let syncingLoadingWindow = self.syncingLoadingWindow, let button = statusBarItem?.button {
            print("showing Sync window")
            if syncingLoadingWindow.isVisible {
                syncingLoadingWindow.orderOut(nil)
            } else {
                if let screen = button.window?.screen {
                    let statusBarFrame = button.window?.frame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
                    let xPosition = statusBarFrame.origin.x
                    let yPosition = screen.frame.maxY - statusBarFrame.height
                    
                    syncingLoadingWindow.setFrameOrigin(NSPoint(x: xPosition, y: yPosition))
                }
                
                syncingLoadingWindow.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    func closeSyncingLoadingWindow() {
        if let syncingLoadingWindow = self.syncingLoadingWindow {
            syncingLoadingWindow.close()
            self.syncingLoadingWindow = nil
            
        }
    }
}
