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
            VStack {
                Text("Launch Screen")
            }
            .onAppear {
                if router.accountManagingUseCase.isSignedIn() {
                    router.push(view: .CreateOrJoinTeamView)
                } else {
                    router.push(view: .LoginView)
                }
            }
            .navigationDestination(for: Router.AsyncCViews.self) { destination in
                router.view(for: destination)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
