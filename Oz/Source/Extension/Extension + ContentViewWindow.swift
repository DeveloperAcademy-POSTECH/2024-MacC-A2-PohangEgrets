//
//  Extension + Window.swift
//  AsyncC
//
//  Created by Jin Lee on 11/16/24.
//

import Foundation
import AppKit
import SwiftUI

extension AppDelegate {
    func makeContentViewWindow() {
        contentViewWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 270, height: 233),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        contentViewWindow?.delegate = self
    }
    
    func setUpContentViewWindow() {
        makeContentViewWindow()
        
        contentViewWindow?.appearance = NSAppearance(named: .aqua)
        contentViewWindow?.level = .floating
        contentViewWindow?.center()
        contentViewWindow?.title = "Oz"
        contentViewWindow?.isReleasedWhenClosed = false
        contentViewWindow?.contentView = NSHostingView(rootView: ContentView().environmentObject(self.router))
        contentViewWindow?.makeKeyAndOrderFront(nil)
    }
    
    func windowWillClose(_ notification: Notification) {
        if let accountDeactivation = self.accountDeactivation {
            accountDeactivation.close()
            self.accountDeactivation = nil
        }
    }
}

