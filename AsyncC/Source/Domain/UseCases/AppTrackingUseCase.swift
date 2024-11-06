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
    private var teamMemberIDs = ["ingt", "mia", "topia"] // 추후에 팀 생성 + 팀 정보 갖고오기 하면 바꿀 예정
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
    
    func setupAppTracking() {
        for member in teamMemberIDs {
            firebaseRepository.setUpListenerForUserAppData(userID: member) { result in
                switch result {
                case .success(let appData):
                    self.updateAppTracking(with: appData)
                case .failure(let error):
                    print(error)
                }
            }
        }
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
