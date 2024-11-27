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
    var teamManagingUseCase: TeamManagingUseCase
    var syncUseCase: SyncUseCase
    
    private var firstSetUp: Bool = true

    
    init() {
        accountManagingUseCase = AccountManagingUseCase(localRepo: localRepository, firebaseRepo: firebaseRepository)
        appTrackingUseCase = AppTrackingUseCase(localRepo: localRepository, firebaseRepo: firebaseRepository)
        syncUseCase = SyncUseCase(localRepo: localRepository, firebaseRepo: firebaseRepository)
        teamManagingUseCase = TeamManagingUseCase(localRepo: localRepository, firebaseRepo: firebaseRepository, appTrackingUseCase: appTrackingUseCase, emoticonUseCase: syncUseCase)
        syncUseCase.router = self
    }
    
    enum AsyncCViews: Hashable {
        case CreateOrJoinTeamView
        case CreateTeamView
        case JoinTeamView
        case MainStatusView
        case LoginView
        case CheckToJoinTeamView(teamCode: String, teamName: String, hostName: String)
        case LogoutView
        case AccountDeleteView
    }
    
    @ViewBuilder func view(for route: AsyncCViews) -> some View {
        switch route{
        case .CreateOrJoinTeamView:
            CreateOrJoinTeamView(viewModel: CreateOrJoinTeamViewModel(teamUseCase: teamManagingUseCase, accountUseCase: accountManagingUseCase))
        case .CreateTeamView:
            CreateTeamView(viewModel: CreateTeamViewModel(teamManagingUseCase: teamManagingUseCase))
        case .JoinTeamView:
            JoinTeamView(viewModel: JoinTeamViewModel(teamManagingUseCase: teamManagingUseCase))
        case .MainStatusView:
            MainStatusView(viewModel: MainStatusViewModel(
                teamManagingUseCase: self.teamManagingUseCase,
                appTrackingUseCase: self.appTrackingUseCase,
                emoticonUseCase: self.syncUseCase))
        case .LoginView:
            LoginView(viewModel: LoginViewModel(accountManagingUseCase: accountManagingUseCase))
        case .LogoutView:
            LogoutView(viewModel: LoginViewModel(accountManagingUseCase: accountManagingUseCase))
        case .CheckToJoinTeamView(let teamCode, let teamName, let hostName):
            CheckToJoinTeamView(viewModel: CheckToJoinTeamViewModel(teamManagingUseCase: teamManagingUseCase),
                                teamCode: teamCode,
                                teamName: teamName,
                                hostName: hostName)
        case .AccountDeleteView:
            AccountDeleteView(viewModel: LoginViewModel(accountManagingUseCase: accountManagingUseCase))
        }
    }
    
    func push(view: AsyncCViews){
        path.append(view)
    }
    
    func pop(){
        path.removeLast()
    }
    
    func setUpStatusBarItem() {
        if let delegate = appDelegate {
            delegate.setUpStatusBarItem()
        }
    }
    
    func removeStatusBarItem() {
        if let delegate = appDelegate {
            delegate.removeStatusBarItem()
        }
    }
    
    func setUpHUDWindow() {
        if let delegate = appDelegate {
            delegate.setUpHUDWindow()
        }
    }
    
    func showHUDWindow() {
        if let delegate = appDelegate {
            delegate.showHUDWindow()
        }
    }
    
    func closeHUDWindow() {
        if let delegate = appDelegate {
            delegate.closeHUDWindow()
        }
    }
    
    func hideHUDWindow() {
        if let delegate = appDelegate {
            delegate.hideHUDWindow()
        }
    }
    
    func setUpContentViewWindow() {
        if let delegate = appDelegate {
            delegate.setUpContentViewWindow()
        }
    }
    
    func isFirstTimeSetUp() -> Bool {
        return firstSetUp
    }
    
    func finishFirstSetUp() {
        firstSetUp = false
    }
    
    // MARK: - PendingSyncRequestView
    func showPendingSyncRequest(senderName: String, senderID: String, recipientName: String, isSender: Bool) {
        if let delegate = appDelegate {
            delegate.setUpPendingSyncWindow(senderName: senderName,
                                            senderID: senderID,
                                            recipientName: recipientName,
                                            isSender: isSender)
            delegate.showPendingSyncWindow()
        }
    }
    
    func closePendingSyncWindow() {
        if let delegate = appDelegate {
            delegate.closePendingSyncWindow()
        }
    }
    
    // MARK: - SyncingView
    func showSyncingLoadingView() {
        if let delegate = appDelegate {
            delegate.setUpSyncingLoadingWindow()
            delegate.showSyncingLoadingWindow()
        }
    }
    
    func closeSyncingLoadingWindow() {
        if let delegate = appDelegate {
            delegate.closeSyncingLoadingWindow()
        }
    }
  
    func setUpExitConfirmation() {
            if let delegate = appDelegate {
                delegate.setUpExitConfirmation()
            }
        }
        
    func showExitConfirmation() {
        if let delegate = appDelegate {
            delegate.showExitConfirmation()
        }
    }
        
    func closeExitConfirmation() {
        if let delegate = appDelegate {
            delegate.closeExitConfirmation()
        }
    }
    
    func setUpDisbandConfirmation() {
        if let delegate = appDelegate {
            delegate.setUpDisbandConfirmation()
        }
    }
    
    func showDisbandConfirmation() {
        if let delegate = appDelegate {
            delegate.showDisbandConfirmation()
        }
    }
    
    func closeDisbandConfirmation() {
        if let delegate = appDelegate {
            delegate.closeDisbandConfirmation()
        }
    }
    
    func exitConfirmation() -> NSPanel? {
        if let delegate = appDelegate {
            return delegate.exitConfirmation
        }
        return nil
    }
    
    func contentViewWindow() -> NSWindow? {
        if let delegate = appDelegate {
            return delegate.contentViewWindow
        }
        return nil
    }

    func setUpAccountDeactivation() {
        if let delegate = appDelegate {
            delegate.setUpAccountDeactivation()
        }
    }
    
    func showAccountDeactivation() {
        if let delegate = appDelegate {
            delegate.showAccountDeactivation()
        }
    }
    
    func closeAccountDeactivation() {
        if let delegate = appDelegate {
            delegate.closeAccountDeactivation()
        }
    }
    
    func accountDeactivation() -> NSPanel? {
        if let delegate = appDelegate {
            return delegate.accountDeactivation
        }
        return nil
    }
}
