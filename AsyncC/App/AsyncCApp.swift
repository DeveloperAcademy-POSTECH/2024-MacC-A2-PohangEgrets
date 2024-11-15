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
    var contentViewWindow: NSWindow?
    let router = Router()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Firebase configure
        FirebaseApp.configure()
        
        setUpContentViewWindow()
        
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
        hudWindow?.contentViewController = NSHostingController(rootView: MainStatusView(viewModel: MainStatusViewModel(teamManagingUseCase: self.router.teamManagingUseCase, appTrackingUseCase: self.router.appTrackingUseCase)))
        
        // Set the CornerRadius for the View inside the NSPanel
        hudWindow?.contentView?.wantsLayer = true
        hudWindow?.contentView?.layer?.cornerRadius = 5.0
        hudWindow?.contentView?.layer?.masksToBounds = true
    }
    
    func makeContentViewWindow() {
        contentViewWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 270, height: 233),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
    }
    
    func setUpContentViewWindow() {
        makeContentViewWindow()
        
        contentViewWindow?.level = .floating
        contentViewWindow?.center()
        contentViewWindow?.title = "AsyncC"
        contentViewWindow?.isReleasedWhenClosed = false
        contentViewWindow?.contentView = NSHostingView(rootView: ContentView().environmentObject(self.router))
        contentViewWindow?.makeKeyAndOrderFront(nil)
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
            ContentView().environmentObject(delegate.router)
        }
    }
}
