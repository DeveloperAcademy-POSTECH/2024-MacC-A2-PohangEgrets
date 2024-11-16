//
//  CreateOrJoinTeamView.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.
//

import SwiftUI

struct CreateOrJoinTeamView: View {
    @EnvironmentObject var router: Router
    var viewModel: CreateOrJoinTeamViewModel
    
    var widthOfButton: CGFloat = 100
    var heightOfButton: CGFloat = 120
    
    
    var body: some View {
        VStack {
            HStack {
                CreateOrJoinTeamButton(actionType: .create)
                Spacer()
                CreateOrJoinTeamButton(actionType: .join)
                
            }.padding(25)
        }
        .frame(width: 270, height: 200)
    }
}
