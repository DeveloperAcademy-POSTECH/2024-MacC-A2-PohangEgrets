//
//  Router.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/12/24.


import Foundation
import SwiftUI

class Router: ObservableObject{
    @Published var path: NavigationPath = NavigationPath()
    
    var appDelegate: AppDelegate?
    
    var firebaseRepository = FirebaseRepository()
    var localRepository = LocalRepository()
    
    var accountManagingUseCase: AccountManagingUseCase
    var appTrackingUseCase: AppTrackingUseCase
    var emoticonUseCase: EmoticonUseCase
    var teamManagingUseCase: TeamManagingUseCase
    
    init() {
        accountManagingUseCase = AccountManagingUseCase(localRepo: localRepository, firebaseRepo: firebaseRepository)
        appTrackingUseCase = AppTrackingUseCase(localRepo: localRepository, firebaseRepo: firebaseRepository)
        emoticonUseCase = EmoticonUseCase(localRepo: localRepository, firebaseRepo: firebaseRepository)
        teamManagingUseCase = TeamManagingUseCase(localRepo: localRepository, firebaseRepo: firebaseRepository, appTrackingUseCase: appTrackingUseCase)
    }
    
    enum AsyncCViews: Hashable{
        case CreateOrJoinTeamView
        case CreateTeamView
        case JoinTeamView
        case MainStatusView
        case LoginView
    }
    
    @ViewBuilder func view(for route: AsyncCViews) -> some View {
        switch route{
        case .CreateOrJoinTeamView:
            CreateOrJoinTeamView(viewModel: CreateOrJoinTeamViewModel(teamUseCase: teamManagingUseCase))
        case .CreateTeamView:
            CreateTeamView(viewModel: CreateTeamViewModel(teamManagingUseCase: teamManagingUseCase))
        case .JoinTeamView:
            JoinTeamView(viewModel: JoinTeamViewModel(teamManagingUseCase: teamManagingUseCase))
        case .MainStatusView:
            MainStatusView(viewModel: MainStatusViewModel(teamManagingUseCase: self.teamManagingUseCase, appTrackingUseCase: self.appTrackingUseCase))
        case .LoginView:
            LoginView(viewModel: LoginViewModel(accountManagingUseCase: accountManagingUseCase))
        }
    }
    
    func push(view: AsyncCViews){
        path.append(view)
    }
    
    func pop(){
        path.removeLast()
    }
    
    func showHUDWindow() {
        if let delegate = appDelegate {
            print("here")
            delegate.showHUDWindow()
        }
    }
}
