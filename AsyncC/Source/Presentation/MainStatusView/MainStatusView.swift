//
//  MainStatusView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

struct MainStatusView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {     
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}
