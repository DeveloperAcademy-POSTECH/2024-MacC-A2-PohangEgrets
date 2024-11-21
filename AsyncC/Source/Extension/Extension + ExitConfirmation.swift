//
//  Extension + ExitConfirmation.swift
//  AsyncC
//
//  Created by Jin Lee on 11/21/24.
//

import AppKit
import SwiftUI

extension AppDelegate {
    func makeExitConfirmation() {
        exitConfirmation = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 140, height: 25),
            styleMask: [.nonactivatingPanel],
            backing: .buffered, defer: false
        )
    }
    
    func setUpmakeExitConfirmation() {
        makeExitConfirmation()
        
        // Remove the default background color of NSPanel
        exitConfirmation?.isOpaque = false
        exitConfirmation?.backgroundColor = .clear
        
        exitConfirmation?.isMovable = false
        exitConfirmation?.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        exitConfirmation?.level = .floating
        exitConfirmation?.contentViewController = NSHostingController(rootView: ExitConfirmationView(viewModel: MainStatusViewModel(teamManagingUseCase: self.router.teamManagingUseCase, appTrackingUseCase: self.router.appTrackingUseCase)).environmentObject(self.router))
        
        // Set the CornerRadius for the View inside the NSPanel
        exitConfirmation?.contentView?.wantsLayer = true
        exitConfirmation?.contentView?.layer?.cornerRadius = 4.0
        exitConfirmation?.contentView?.layer?.masksToBounds = true
        
        exitConfirmation?.appearance = NSAppearance(named: .aqua)
    }
    
    func showExitConfirmation() {
        if let exitConfirmation = self.exitConfirmation, let button = statusBarItem?.button {
            if exitConfirmation.isVisible {
                exitConfirmation.orderOut(nil)
            } else {
                if let screen = button.window?.screen {
                    let statusBarFrame = button.window?.frame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
                    let xPosition = statusBarFrame.origin.x + 270 - 8
                    let yPosition = screen.frame.maxY - statusBarFrame.height - 32 - 15
                    
                    exitConfirmation.setFrameOrigin(NSPoint(x: xPosition, y: yPosition))
                }
                
                exitConfirmation.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    func closeExitConfirmation() {
        if let exitConfirmation = self.exitConfirmation {
            exitConfirmation.close()
            self.exitConfirmation = nil
        }
    }
}
