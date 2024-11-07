//
//  AppTrackingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

import Foundation

final class AppTrackingUseCase: ObservableObject {
    
    private let firebaseRepository: FirebaseRepository
    private let localRepository: LocalRepository
    @Published var teamMemberAppTrackings: [String: [String]] = [:]
    
    init() {
        firebaseRepository = FirebaseRepository()
        localRepository = LocalRepository()
    }
    
    private func updateAppTracking(appName: String) {
        let id = getUserIDFromLocal()
        let epochSeconds = Int(Date().timeIntervalSince1970)
        firebaseRepository.setUserAppData(id: id, appName: appName, epochSeconds: epochSeconds)
    }
    
    private func getUserIDFromLocal() -> String {
        return localRepository.getUserID()
    }
    
    func setupAppTracking(fbRepository: FirebaseRepository, teamMemberIDs: [String]) {
        let userID = getUserIDFromLocal()
        fbRepository.setUpListenersForUserAppData(userIDToIgnore: userID, userIDsToTrack: teamMemberIDs) { result in
            switch result {
            case .success(let appData):
                self.updateAppTracking(with: appData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func resetAppTrackings() {
        teamMemberAppTrackings.removeAll()
    }
    
    private func updateAppTracking(with updatedData: UserAppData) {
        let userID = updatedData.userID
        var appData = updatedData.appData
        var arrayOfLatestApps = [String](repeating: "", count: 5)
        var count = min(4, appData.count - 1)
        var uniqueApps: Set<String> = []
        
        while count >= 0 {
            let appName = appData.removeLast().0
            if !uniqueApps.contains(appName) {
                uniqueApps.insert(appName)
                arrayOfLatestApps[count] = appName
            }
            count -= 1
        }
        arrayOfLatestApps.removeAll(where: {$0 == ""})
        teamMemberAppTrackings[userID] = arrayOfLatestApps
        print(teamMemberAppTrackings)
    }
    
}
