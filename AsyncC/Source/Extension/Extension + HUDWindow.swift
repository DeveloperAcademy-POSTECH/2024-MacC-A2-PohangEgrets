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
                    syncUseCase: self.router.syncUseCase,
                    accountUseCase: self.router.accountManagingUseCase)
            ).environmentObject(self.router))
        
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
                    var xPosition = statusBarFrame.origin.x
                    let yPosition = screen.frame.maxY - statusBarFrame.height
                    
                    let tempXPosition = screen.frame.maxX - statusBarFrame.origin.x
                    if tempXPosition < 400 {
                        xPosition = statusBarFrame.origin.x - (400 - tempXPosition)
                    }
                    
                    hudWindow.setFrameOrigin(NSPoint(x: xPosition, y: yPosition))
                }
                
                hudWindow.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    func hideHUDWindow() {
        guard let hudWindow else { return }
        if hudWindow.isVisible {
            hudWindow.orderOut(nil)
        }
    }
    
    func closeHUDWindow() {
        if let hudWindow = self.hudWindow {
            hudWindow.close()
            self.hudWindow = nil
            
        }
    }
}
