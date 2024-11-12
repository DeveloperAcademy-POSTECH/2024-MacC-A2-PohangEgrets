//
//  ContentView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/5/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button {
                router.push(view: .CreateOrJoinTeamView)
            } label: {
                Text("click here")
            }
            Text("Hello, world!")
                .navigationDestination(for: Router.AsyncCViews.self) { destination in
                    router.view(for: destination)
                }
        }
    }
}

#Preview {
    ContentView()
}
