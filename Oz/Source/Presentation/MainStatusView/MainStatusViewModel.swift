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
import FirebaseAuth

class MainStatusViewModel: ObservableObject {
    var teamManagingUseCase: TeamManagingUseCase
    var appTrackingUseCase: AppTrackingUseCase
    var syncUseCase: SyncUseCase
    var accountUseCase: AccountManagingUseCase
    
    var cancellables = Set<AnyCancellable>()
    @Published var nameToUserId: [String: String] = [:] {
        didSet {
            print("nameToUserId: \(nameToUserId)")
        }
    }
    @Published var trackingActive: [String: Bool] = [:] // 유저별 TrackingActive 상태
    @Published var appTrackings: [String: [String]] = [:] {
        didSet {
            print("viewModel.appTrackings: \(appTrackings)")
            objectWillChange.send()
        }
    }
    @Published var userName: String = ""
    @Published var teamName: String = ""
    @Published var hostName: String = ""
    @Published var teamMembers: [String] = []
    @Published var isTeamHost: Bool = false
    @Published var isToggled: Bool = true
    @Published var isMenuVisible: Bool = false
    @Published var userNameAndID: [String: String] = [:] // [userName: userID]
    @Published var isSelectedButton: Bool = false
    @Published var buttonStates: [String: Bool] = [:]
    @Published var isAppIconHover: Bool = false
    @Published var isLeaveRoomTextHover: Bool = false
    @Published var isCopyTeamCode: Bool = false {
        didSet {
            if isCopyTeamCode == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isCopyTeamCode = false
                    }
                }
            }
        }
    }
    
    init(teamManagingUseCase: TeamManagingUseCase, appTrackingUseCase: AppTrackingUseCase, syncUseCase: SyncUseCase, accountUseCase: AccountManagingUseCase) {
        self.teamManagingUseCase = teamManagingUseCase
        self.appTrackingUseCase = appTrackingUseCase
        self.syncUseCase =  syncUseCase
        self.accountUseCase = accountUseCase
        
        appTrackingUseCase.$teamTrackingStatus
            .receive(on: RunLoop.main)
            .sink { [weak self] newStatus in
                self?.trackingActive = newStatus
            }
            .store(in: &cancellables)
    }
    
    func updateUserTrackingStatus(userID: String, isActive: Bool) {
        trackingActive[userID] = isActive
        appTrackingUseCase.updateTrackingStatus(for: userID, isActive: isActive)
    }
    
    func startTrackingStatuses(for teamMemberIDs: [String]) {
        appTrackingUseCase.startTrackingStatus(for: teamMemberIDs)
    }
    
    func getTeamData(teamCode: String) {
        teamManagingUseCase.getTeamDetails(teamCode: teamCode) { [weak self] result in
            switch result {
            case .success(let details):
                DispatchQueue.main.async {
                    self?.teamName = details.teamName
                    self?.hostName = details.hostName
                    self?.teamMembers = details.teamMemberIDs
                    self?.startTrackingStatuses(for: self?.teamMembers ?? [])
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
        return userName == key
    }
    
    func getTeamName() -> String {
        teamManagingUseCase.getTeamName()
    }
    
    func getTeamCode() -> String {
        teamManagingUseCase.getTeamCode()
    }
    
    func getUserName() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("MainStatusViewModel: 현재 유저 아이디를 받아올 수 없습니다.")
            return
        }
        
        accountUseCase.getUserName(userID: userID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userName):
                self.userName = userName
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func getUserID() -> String {
        teamManagingUseCase.getUserID()
    }
    
    func leaveTeam() {
        teamManagingUseCase.leaveTeam()
    }
    
    func stopAppTracking() { // 본인
        appTrackingUseCase.stopAppTracking()
    }
    
    func stopOtherUserAppTracking() { // 다른 사람 앱 추적 리스너 삭제
        appTrackingUseCase.stopListeningToOtherUsers()
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
                                self.nameToUserId[userName] = userID // 이름-유저 ID 매핑 저장
                            
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
    
    func startAppTracking() {
        appTrackingUseCase.startAppTracking()
    }
    
    func setUpAllListener() {
        let teamCode = self.getTeamCode()
        
        teamManagingUseCase.getTeamMetaData(for: teamCode) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let teamMetaData):
                self.teamManagingUseCase.setUpAllListeners(using: teamMetaData)
            case .failure(let error):
                print("Failed to fetch team metadata: \(error.localizedDescription)")
            }
        }
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
        if lhs == self.userName { return true }
        if rhs == self.userName { return false }
        
        if lhs == self.hostName { return true }
        if rhs == self.hostName { return false }
        
        return lhs < rhs
    }
    
    func copyTeamCode() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self.getTeamCode(), forType: .string)
        isCopyTeamCode = true
        print("팀 코드 복사")
    }
    
    func isButtonSelected(for key: String) -> Bool {
        return buttonStates[key] ?? false
    }
    
    func toggleButtonSelection(for key: String) {
        buttonStates[key] = !(buttonStates[key] ?? false)
    }
    
    private func changeDisbandStatus() {
        teamManagingUseCase.changeToDisbandStatus(teamCode: teamManagingUseCase.getTeamCode())
    }
    
    func disbandTeam() {
        teamManagingUseCase.changeToDisbandStatus(teamCode: teamManagingUseCase.getTeamCode())
    }
}

