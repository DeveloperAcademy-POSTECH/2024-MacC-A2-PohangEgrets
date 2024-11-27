//
//  Extension + ExitConfirmation.swift
//  AsyncC
//
//  Created by Jin Lee on 11/21/24.
//

import AppKit
import SwiftUI

extension AppDelegate {
    func makeDisbandConfirmation() {
        exitConfirmation = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 140, height: 25),
            styleMask: [.nonactivatingPanel],
            backing: .buffered, defer: false
        )
    }
    
    func setUpDisbandConfirmation() {
        makeExitConfirmation()
        
        // Remove the default background color of NSPanel
        exitConfirmation?.isOpaque = false
        exitConfirmation?.backgroundColor = .clear
        
        exitConfirmation?.isMovable = false
        exitConfirmation?.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        exitConfirmation?.level = .popUpMenu
        exitConfirmation?.contentViewController = NSHostingController(rootView: DisbandConfirmationView(viewModel: MainStatusViewModel(teamManagingUseCase: self.router.teamManagingUseCase, appTrackingUseCase: self.router.appTrackingUseCase, emoticonUseCase: self.router.syncUseCase)).environmentObject(self.router))
        
        // Set the CornerRadius for the View inside the NSPanel
        exitConfirmation?.contentView?.wantsLayer = true
        exitConfirmation?.contentView?.layer?.cornerRadius = 4.0
        exitConfirmation?.contentView?.layer?.masksToBounds = true
        
        exitConfirmation?.appearance = NSAppearance(named: .aqua)
    }
    
    func showDisbandConfirmation() {
        if let exitConfirmation = self.exitConfirmation, let hudWindow = self.hudWindow {
            if exitConfirmation.isVisible {
                exitConfirmation.orderOut(nil)
            } else {
                if let hudScreen = hudWindow.screen {
                    let hudFrame = hudWindow.frame
                    let xPosition = hudFrame.origin.x + 230
                    let yPosition = hudFrame.origin.y + hudWindow.frame.height - 70

                    exitConfirmation.setFrameOrigin(NSPoint(x: xPosition, y: yPosition))
                    exitConfirmation.makeKeyAndOrderFront(nil)
                }
            }
        }
    }
    
    func closeDisbandConfirmation() {
        if let exitConfirmation = self.exitConfirmation {
            exitConfirmation.close()
            self.exitConfirmation = nil
        }
    }
}
