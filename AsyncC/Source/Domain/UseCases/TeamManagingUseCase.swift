//
//  TeamManagingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/7/24.
//

import Foundation

final class TeamManagingUseCase {
    
    private let firebaseRepository: FirebaseRepository
    private let localRepository: LocalRepository
    private let appTrackingUseCase: AppTrackingUseCase
    
    init() {
        firebaseRepository = FirebaseRepository()
        localRepository = LocalRepository()
        appTrackingUseCase = AppTrackingUseCase()
    }
    
    // MARK: - 새로운 Team 생성
    func createNewTeam(teamName: String) -> String {
        let teamCode = generateTeamCode()
        let hostID = localRepository.getUserID()
        let teamMetaData = TeamMetaData(memberIDs: [hostID], teamName: teamName, inviteCode: teamCode, hostID: hostID)
        
        firebaseRepository.createNewTeamInFirestore(teamData: teamMetaData) { result in
            switch result {
            case .success(let message):
                print(message)
                self.localRepository.saveTeamCode(teamMetaData.inviteCode)
                self.setUpAllListeners(using: teamMetaData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return teamCode
    }
    
    private func generateTeamCode() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyz0123456789"
        
        return String((0..<6).compactMap { _ in characters.randomElement() })
    }
    
    // MARK: - 기존 Team 참가
    func addNewMemberToTeam(teamCode: String) {
        let userID = localRepository.getUserID()
        
        firebaseRepository.addNewMemberToTeam(teamCode: teamCode, userID: userID) { result in
            switch result {
            case .success(let teamData):
                let teamInviteCode = teamData.inviteCode
                self.localRepository.saveTeamCode(teamInviteCode)
                self.setUpAllListeners(using: teamData)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Listener 생성 및 업데이트
    private func setUpAllListeners(using teamData: TeamMetaData) {
        let teamInviteCode = teamData.inviteCode
        
        self.firebaseRepository.setUpListenerForTeamData(teamCode: teamInviteCode) { result in
            
            switch result {
            case .success(let teamData):
                if teamData.memberIDs.isEmpty {
                    self.leaveTeam()
                } else {
                    self.refreshUserAppDataListeners(for: teamData.memberIDs)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func refreshUserAppDataListeners(for updatedMemberIDs: [String]) {
        firebaseRepository.removeListenersForUserAppData()
        appTrackingUseCase.resetAppTrackings()
        appTrackingUseCase.setupAppTracking(fbRepository: firebaseRepository, teamMemberIDs: updatedMemberIDs)
    }
    
    // MARK: - Team 정보 갖고오기
    func getTeamNameAndHostName(for teamInviteCode: String,
                                handler: @escaping ((Result<(teamName: String, hostName: String), Error>)) -> Void) {
        firebaseRepository.getTeamData(teamCode: teamInviteCode) { result in
            switch result {
            case .success(let teamData):
                self.firebaseRepository.getHostName(hostID: teamData.hostID) { hostNameResult in
                    switch hostNameResult {
                    case .success(let hostName):
                        print((teamName: teamData.teamName, hostName: hostName))
                        handler(.success((teamName: teamData.teamName, hostName: hostName)))
                    case .failure(let error):
                        handler(.failure(error))
                    }
                    
                }
            case .failure(let error):
                handler(.failure(error))
            }
            
        }
    }
    
    // MARK: - Team 나가기 및 지우기 
    func leaveTeam() {
        let userID = localRepository.getUserID()
        let teamCode = localRepository.getTeamCode()
        
        
        firebaseRepository.removeListenersForUserAppData()
        appTrackingUseCase.resetAppTrackings()
        firebaseRepository.removeTeamListener()
        firebaseRepository.removeUser(userID: userID, teamCode: teamCode)
        localRepository.resetTeamCode()
    }
    
    func deleteTeam() {
        let teamCode = localRepository.getTeamCode()
        firebaseRepository.removeAllUsersInTeam(teamCode: teamCode)
    }
}
