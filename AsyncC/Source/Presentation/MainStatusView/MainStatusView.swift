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
            Text("Status View")
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
