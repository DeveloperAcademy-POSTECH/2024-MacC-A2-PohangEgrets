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
