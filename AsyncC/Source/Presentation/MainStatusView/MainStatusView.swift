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
        .frame(width: 200, height: 200)
        .fixedSize(horizontal: false, vertical: false)
    }
}
