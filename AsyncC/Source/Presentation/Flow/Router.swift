//
//  Router.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.


import Foundation
import SwiftUI

class Router: ObservableObject{
    @Published var path: NavigationPath = NavigationPath()
    
    enum AsyncCViews: Hashable{
        case CreateOrJoinTeamView
    }
    
    @ViewBuilder func view(for route: AsyncCViews) -> some View {
        switch route{
        case .CreateOrJoinTeamView:
            CreateOrJoinTeamView()
        }
    }
    
    func push(view: AsyncCViews){
        path.append(view)
    }
    
    func pop(){
        path.removeLast()
    }
}
