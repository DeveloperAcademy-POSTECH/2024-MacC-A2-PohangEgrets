//
//  AsyncCApp.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/5/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Firebase configure
        FirebaseApp.configure()
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(systemSymbolName: "star", accessibilityDescription: "Status Bar Icon")
            button.action = #selector(togglePopover)
        }
        
        var router = Router()
        
        popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView().environmentObject(router))
        
    }
    
    @objc func togglePopover() {
        if let button = statusBarItem?.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}

@main
struct AsyncCApp: App {
  // register app delegate for Firebase setup
  @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
      // Remove WindowGroup to prevent the main window from appearing
      // and only display the Status Bar item.
      Settings {
          EmptyView()
      }
  }
}
