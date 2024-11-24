//
//  Extension + StatusBar.swift
//  AsyncC
//
//  Created by Jin Lee on 11/16/24.
//

import Foundation
import AppKit

extension AppDelegate {
    func setUpStatusBarItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(systemSymbolName: "star", accessibilityDescription: "Status Bar Icon")
            button.action = #selector(toggleHUDWindow)
        }
    }
    
    @objc func toggleHUDWindow() {
        if let hudWindow = self.hudWindow, let button = statusBarItem?.button {
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
    
    func removeStatusBarItem() {
        if let item = statusBarItem {
            NSStatusBar.system.removeStatusItem(item)
            statusBarItem = nil
        }
    }
}
