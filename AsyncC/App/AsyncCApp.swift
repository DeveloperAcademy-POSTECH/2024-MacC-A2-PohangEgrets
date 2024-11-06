//
//  AsyncCApp.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/5/24.
//


import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        FirebaseApp.configure()
    }
}

@main
struct AsyncCApp: App {
  // register app delegate for Firebase setup
  @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
        ContentView()
    }
  }
}
