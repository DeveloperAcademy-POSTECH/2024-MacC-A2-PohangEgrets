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
    @Published var hostName: String = ""
    
    init(teamManagingUseCase: TeamManagingUseCase, appTrackingUseCase: AppTrackingUseCase) {
        self.teamManagingUseCase = teamManagingUseCase
        self.appTrackingUseCase = appTrackingUseCase
        self.startShowingAppTracking()
    }
    
    func updateHostName(teamCode: String) {
        teamManagingUseCase.getTeamNameAndHostName(for: teamCode) { [weak self] result in
            switch result {
            case .success(_, let hostName):
                DispatchQueue.main.async {
                    self?.hostName = hostName
                }
            case .failure(let error):
                print("Failed to fetch host name: \(error)")
            }
        }
    }
    
    func getTeamName() -> String {
        teamManagingUseCase.getTeamName()
    }
    
    func getTeamCode() -> String {
        teamManagingUseCase.getTeamCode()
    }
    
    func startShowingAppTracking() {
        appTrackingUseCase.$teamMemberAppTrackings
            .receive(on: RunLoop.main)
            .sink { [weak self] appTrackings in
                self?.appTrackings = appTrackings
            }
            .store(in: &cancellables)
    }
    
    
    func addAppTracking(for user: String, appName: String) {
        var apps = appTrackings[user] ?? []
        apps.append(appName)
        
        if apps.count > 3 {
            apps.removeFirst()
        }
        
        appTrackings[user] = apps
    }
}
