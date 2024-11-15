//
//  AsyncCApp.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/5/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, NSApplicationDelegate {
    private var launchWindowController: NSWindowController?
    var statusBarItem: NSStatusItem?
    var hudWindow: NSPanel?
    let router = Router()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Firebase configure
        FirebaseApp.configure()
                
        setUpStatusBarItem()
        
        setUpHUDWindow()
        
        router.appDelegate = self
        
    }
    
    func setUpStatusBarItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(systemSymbolName: "star", accessibilityDescription: "Status Bar Icon")
            button.action = #selector(toggleHUDWindow)
        }
    }
    
    func makeHUDWindow() {
        hudWindow = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.nonactivatingPanel, .titled],
            backing: .buffered, defer: false
        )
    }
    
    func setUpHUDWindow() {
        makeHUDWindow()
        
        // Remove the default background color of NSPanel
        hudWindow?.isOpaque = false
        hudWindow?.backgroundColor = .black
        
        hudWindow?.isMovable = false
        hudWindow?.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        hudWindow?.level = .floating
        hudWindow?.contentViewController = NSHostingController(rootView: MainStatusView(viewModel: MainStatusViewModel(teamManagingUseCase: self.router.teamManagingUseCase, appTrackingUseCase: self.router.appTrackingUseCase)))
        
        // Set the CornerRadius for the View inside the NSPanel
        hudWindow?.contentView?.wantsLayer = true
        hudWindow?.contentView?.layer?.cornerRadius = 5.0
        hudWindow?.contentView?.layer?.masksToBounds = true
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
    
}

@main
struct AsyncCApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(delegate.router)
                .preferredColorScheme(.light)
        }
    }
}
