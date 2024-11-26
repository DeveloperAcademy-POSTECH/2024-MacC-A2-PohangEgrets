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
            if let image = NSImage(named: "sync") {
                let newSize = NSSize(width: 16, height: 16)
                let resizedImage = image.resized(to: newSize)
                
                button.image = resizedImage
            }
            button.action = #selector(toggleHUDWindow)
        }
    }
    
    @objc func toggleHUDWindow() {
        if let hudWindow = self.hudWindow, let button = statusBarItem?.button {
            if hudWindow.isVisible {
                hudWindow.orderOut(nil)
                // If the HUD window is closed, make sure the exitConfirmation is also closed.
                if let exitConfirmation = self.exitConfirmation {
                    exitConfirmation.close()
                    self.exitConfirmation = nil
                }
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

extension NSImage {
    func resized(to newSize: NSSize) -> NSImage {
        // 새로운 크기로 이미지 객체를 생성
        let resizedImage = NSImage(size: newSize)
        
        // 이미지를 그리기 위해 lockFocus 호출
        resizedImage.lockFocus()
        
        // 기존 이미지를 새로운 크기로 그린다
        self.draw(in: NSRect(origin: .zero, size: newSize))
        
        // 그리기 완료 후 unlockFocus 호출
        resizedImage.unlockFocus()
        
        return resizedImage
    }
}
