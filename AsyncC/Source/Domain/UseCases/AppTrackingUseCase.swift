//
//  AppTrackingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

import Foundation

final class AppTrackingUseCase {
    
    private let firebaseRepository: FirebaseRepository
    private let localRepository: LocalRepository
    
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
    
}
