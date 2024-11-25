//
//  AppTrackingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

import Foundation
import AppKit

final class AppTrackingUseCase: ObservableObject {
    
    private let firebaseRepository: FirebaseRepositoryProtocol
    private let localRepository: LocalRepositoryProtocol
    private var currentApp: NSRunningApplication? = nil
    private var appTrackingObserver: NSObjectProtocol?
    @Published var teamMemberAppTrackings: [String: [String]] = [:]
    @Published var teamTrackingStatus: [String: Bool] = [:]

    init(localRepo: LocalRepositoryProtocol, firebaseRepo: FirebaseRepositoryProtocol) {
        self.localRepository = localRepo
        self.firebaseRepository = firebaseRepo
    }

    func startTrackingStatus(for teamMemberIDs: [String]) {
        for userID in teamMemberIDs {
            firebaseRepository.setUpListenerForTrackingActive(for: userID) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let isActive):
                        self.teamTrackingStatus[userID] = isActive
                    case .failure:
                        self.teamTrackingStatus[userID] = true
                    }
                }
            }
        }
    }
    
    func toggleCurrentUserTrackingStatus() { // 자신의 TrackingActive 상태를 변경하는 메서드:
        let currentUserID = getUserIDFromLocal()
        let currentStatus = teamTrackingStatus[currentUserID] ?? true
        let newStatus = !currentStatus
        updateTrackingStatus(for: currentUserID, isActive: newStatus)
    }
    
    func updateTrackingStatus(for userID: String, isActive: Bool) { // 특정 사용자의 TrackingActive 상태를 업데이트하는 메서드:
        firebaseRepository.setTrackingActive(id: userID, isActive: isActive)
    }
    
    func isUserTrackingActive(userID: String) -> Bool { // 특정 사용자의 상태가 true인지 확인하는 메서드
        return teamTrackingStatus[userID] ?? true // 기본값 true
    }
    
    func startAppTracking() {
        guard appTrackingObserver == nil else { return } // 이미 등록된 경우 중복 방지
        appTrackingObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
                self.handleAppChangedIfNeeded(app: app)
            }
        }
    }
    
    private func handleAppChangedIfNeeded(app: NSRunningApplication) {
        if self.currentApp != app {
            self.currentApp = app
            self.handleAppChanged(app: app)
        }
    }
    
    private func handleAppChanged(app: NSRunningApplication) {
        if let appName = app.localizedName {
            updateAppTracking(appName: appName)
        } else {
            updateAppTracking(appName: "Unknown")
        }
    }
    
    func stopAppTracking() {
        if let observer = appTrackingObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
            appTrackingObserver = nil
        }
    }
    
    func stopListeningToOtherUsers() { // 다른 사람 앱 리스너 삭제
        firebaseRepository.removeListenersForUserAppData()
    }
    
    private func updateAppTracking(appName: String) {
        let id = getUserIDFromLocal()
        let epochSeconds = Int(Date().timeIntervalSince1970)
        firebaseRepository.setUserAppData(id: id, appName: appName, epochSeconds: epochSeconds)
        
        DispatchQueue.main.async {
            self.teamMemberAppTrackings[id] = [appName]
        }
    }
    
    private func getUserIDFromLocal() -> String {
        return localRepository.getUserID()
    }
    
    func setupAppTracking(teamMemberIDs: [String]) {
        let userID = getUserIDFromLocal()
        firebaseRepository.setUpListenersForUserAppData(userIDToIgnore: userID, userIDsToTrack: teamMemberIDs) { result in
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
        var arrayOfLatestApps = [String](repeating: "", count: 3)
        var count = min(2, appData.count - 1)
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
    }
}
