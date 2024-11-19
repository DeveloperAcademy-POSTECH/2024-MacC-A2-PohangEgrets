//
//  MainStatusViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/13/24.
//

//
//  MainStatusViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/13/24.
//

import SwiftUI
import Combine

class MainStatusViewModel: ObservableObject {
    var teamManagingUseCase: TeamManagingUseCase
    var appTrackingUseCase: AppTrackingUseCase
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var appTrackings: [String: [String]] = [:]
    @Published var teamName: String = ""
    @Published var hostName: String = ""
    @Published var teamMembers: [String] = []
    @Published var isTeamHost: Bool = false
    @Published var isMenuVisible: Bool = false

    init(teamManagingUseCase: TeamManagingUseCase, appTrackingUseCase: AppTrackingUseCase) {
        self.teamManagingUseCase = teamManagingUseCase
        self.appTrackingUseCase = appTrackingUseCase
    }
    
    func getTeamData(teamCode: String) {
        teamManagingUseCase.getTeamDetails(teamCode: teamCode) { [weak self] result in
            switch result {
            case .success(let details):
                DispatchQueue.main.async {
                    self?.teamName = details.teamName
                    self?.hostName = details.hostName
                }
                self?.checkHost()
                
            case .failure(let error):
                print("Failed to fetch host name: \(error)")
            }
        }
    }
    
    func checkHost() {
        let userID = teamManagingUseCase.getUserID()
        let teamCode = teamManagingUseCase.getTeamCode()
        
        teamManagingUseCase.checkHost(userID: userID, teamID: teamCode) { [weak self] isHost in
            DispatchQueue.main.async {
                self?.isTeamHost = isHost
            }
        }
    }
    
    func getTeamName() -> String {
        teamManagingUseCase.getTeamName()
    }
    
    func getTeamCode() -> String {
        teamManagingUseCase.getTeamCode()
    }
    
    func getUserName() -> String {
        teamManagingUseCase.getUserName()
    }
    
    func getUserID() -> String {
        teamManagingUseCase.getUserID()
    }
    
    func leaveTeam() {
        teamManagingUseCase.leaveTeam()
    }
    
    func startShowingAppTracking() {
        appTrackingUseCase.$teamMemberAppTrackings
            .receive(on: RunLoop.main)
            .sink { [weak self] appTrackings in
                guard let self = self else { return }
                var updatedTrackings: [String: [String]] = [:]
                
                let userIDs = Array(appTrackings.keys)
                
                for userID in userIDs {
                    self.teamManagingUseCase.getUserNameConvert(userID: userID) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let userName):
                                updatedTrackings[userName] = appTrackings[userID]?.reversed()
                            case .failure(let error):
                                print("Failed to get user name for userID \(userID): \(error)")
                                updatedTrackings[userID] = appTrackings[userID]
                            }
                            
                            if updatedTrackings.count == appTrackings.count {
                                self.appTrackings = updatedTrackings
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func getOpacity(appName: String, apps: [String]) -> Double {
        guard let index = apps.firstIndex(of: appName) else { return 1.0 }
        return index == 0 ? 1.0 : (index <= 2 ? 0.3 : 1.0)
    }
    
    func containsXcode(apps: [String]) -> Bool {
        if apps.firstIndex(of: "Xcode") == 0 {
            return true
        }
        return false
    }
    
    func customSort(lhs: String, rhs: String) -> Bool {
        if lhs == self.getUserName() { return true }
        if rhs == self.getUserName() { return false }
        
        if lhs == self.hostName { return true }
        if rhs == self.hostName { return false }
        
        return lhs < rhs
    }
    
    func copyTeamCode() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self.getTeamCode(), forType: .string)
        print("팀 코드 복사")
    }
}
