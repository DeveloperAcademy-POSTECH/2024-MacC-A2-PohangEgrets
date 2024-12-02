//
//  AsyncCApp.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/5/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var launchWindowController: NSWindowController?
    var statusBarItem: NSStatusItem?
    var hudWindow: NSPanel?
    
    var pendingSyncWindow: NSPanel?
    var contentViewWindow: NSWindow?
    let router = Router()
    var exitConfirmation: NSPanel?
    var accountDeactivation: NSPanel?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Firebase configure
        FirebaseApp.configure()
        setUpContentViewWindow()
        router.appDelegate = self
    }
}

@main
struct AsyncCApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        Settings {
            ContentView()
                .environmentObject(delegate.router)
                .preferredColorScheme(.light)
        }
    }
}
