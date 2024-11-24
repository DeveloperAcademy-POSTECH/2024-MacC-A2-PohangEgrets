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
    var emoticonUseCase: EmoticonUseCase
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var appTrackings: [String: [String]] = [:]
    @Published var teamName: String = ""
    @Published var hostName: String = ""
    @Published var teamMembers: [String] = []
    @Published var isTeamHost: Bool = false
    @Published var isToggled: Bool = true
    @Published var isMenuVisible: Bool = false
   @Published var userNameAndID: [String: String] = [:] // [userName: userID]
      @Published var isSelectedButton: Bool = false
    @Published var buttonStates: [String: Bool] = [:]
    
    init(teamManagingUseCase: TeamManagingUseCase, appTrackingUseCase: AppTrackingUseCase, emoticonUseCase: EmoticonUseCase) {
        self.teamManagingUseCase = teamManagingUseCase
        self.appTrackingUseCase = appTrackingUseCase
        self.emoticonUseCase =  emoticonUseCase
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
    
    func checkUser(key: String) -> Bool {
        return getUserName() == key
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
    
    func stopAppTracking() {
        appTrackingUseCase.stopAppTracking()
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
                        // [userID: userName]
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let userName):
                                self.userNameAndID[userName] = userID
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
    
    func isButtonSelected(for key: String) -> Bool {
        return buttonStates[key] ?? false
    }
    
    func toggleButtonSelection(for key: String) {
        buttonStates[key] = !(buttonStates[key] ?? false)
    }
}
