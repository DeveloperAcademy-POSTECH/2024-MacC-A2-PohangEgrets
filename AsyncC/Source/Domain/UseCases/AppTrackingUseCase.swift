//
//  AppTrackingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

import Foundation

final class AppTrackingUseCase {
    
    private let firebaseRepository: FirebaseRepository
    
    init() {
        firebaseRepository = FirebaseRepository()
    }
    
    func updateAppTracking(appName: String) {
        let id = getUserID()
        let epochSeconds = Int(Date().timeIntervalSince1970)
        firebaseRepository.setUserAppData(id: id, appName: appName, epochSeconds: epochSeconds)
    }
    
    func getUserID() -> String {
        // Data layer에서 user default 갖고오기
        return "mia"
    }
}
