//
//  TeamManagingUseCase.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/7/24.
//

import Foundation
import AppKit

final class TeamManagingUseCase {
    
    private let firebaseRepository: FirebaseRepositoryProtocol
    private let localRepository: LocalRepositoryProtocol
    private let appTrackingUseCase: AppTrackingUseCase
    private let syncUseCase: SyncUseCase
    
    init(localRepo: LocalRepositoryProtocol, firebaseRepo: FirebaseRepositoryProtocol, appTrackingUseCase: AppTrackingUseCase, syncUseCase: SyncUseCase) {
        self.localRepository = localRepo
        self.firebaseRepository = firebaseRepo
        self.appTrackingUseCase = appTrackingUseCase
        self.syncUseCase = syncUseCase
    }
    
    // MARK: - 새로운 Team 생성
    func createNewTeam(teamName: String) -> String {
        let teamCode = generateTeamCode()
        let hostID = localRepository.getUserID()
        let teamMetaData = TeamMetaData(memberIDs: [hostID], teamName: teamName, inviteCode: teamCode, hostID: hostID, isDisband: "false")
        
        firebaseRepository.createNewTeamInFirestore(teamData: teamMetaData) { result in
            switch result {
            case .success(let message):
                self.onboardTeam(teamData: teamMetaData)
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
                self.onboardTeam(teamData: teamData)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func onboardTeam(teamData: TeamMetaData) {
        let teamInviteCode = teamData.inviteCode
        self.localRepository.saveTeamCode(teamInviteCode)
        self.localRepository.saveTeamName(teamData.teamName)
        self.appTrackingUseCase.startAppTracking()
        self.setUpAllListeners(using: teamData)
    }
    
    // MARK: - Listener 생성 및 업데이트
    func setUpAllListeners(using teamData: TeamMetaData) {
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
        
        syncUseCase.setUpListenerForEmoticons(userID: localRepository.getUserID())
        
    }
    
    private func refreshUserAppDataListeners(for updatedMemberIDs: [String]) {
        firebaseRepository.removeListenersForUserAppData()
        appTrackingUseCase.resetAppTrackings()
        appTrackingUseCase.setupAppTracking(teamMemberIDs: updatedMemberIDs) //  새롭게 업데이트된 멤버 ID를 기반으로 사용자 앱 데이터를 추적하는 리스너를 추가합니다.
    }
    
    func getUserNameConvert(userID: String, handler: @escaping (Result<String, Error>) -> Void) {
        firebaseRepository.getUserName(userID: userID) { result in
            handler(result)
        }
    }
    
    func getUserEmailConvert(userID: String, handler: @escaping (Result<String, Error>) -> Void) {
        firebaseRepository.getUserEmail(userID: userID) { result in
            handler(result)
        }
    }

    // MARK: - Team 정보 갖고오기
    
    func getTeamMetaData(for teamCode: String, handler: @escaping (Result<TeamMetaData, Error>) -> Void) {
        firebaseRepository.getTeamData(teamCode: teamCode) { result in
            switch result {
            case .success(let teamData):
                handler(.success(teamData))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
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
    
    func getTeamMembers(
        teamCode: String,
        handler: @escaping (Result<[String], Error>) -> Void
    ) {
        firebaseRepository.getTeamData(teamCode: teamCode) { [weak self] result in
            switch result {
            case .success(let teamData):
                self?.firebaseRepository.getUsersForMembersIDs(memberIDs: teamData.memberIDs) { membersResult in
                    switch membersResult {
                    case .success(let teamMembers):
                        handler(.success(teamMembers))
                    case .failure(let error):
                        handler(.failure(error))
                    }
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func getTeamDetails(
        teamCode: String,
        handler: @escaping (Result<(teamMemberIDs: [String], teamName: String, hostName: String), Error>) -> Void
    ) {
        firebaseRepository.getTeamData(teamCode: teamCode) { [weak self] result in
            switch result {
            case .success(let teamData):
                self?.firebaseRepository.getHostName(hostID: teamData.hostID) { hostNameResult in
                    switch hostNameResult {
                    case .success(let hostName):
                        handler(.success((teamMemberIDs:teamData.memberIDs, teamName: teamData.teamName, hostName: hostName)))
                    case .failure(let error):
                        handler(.failure(error))
                    }
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func checkHost(userID: String, teamID: String, completion: @escaping (Bool) -> Void) {
        firebaseRepository.getTeamData(teamCode: teamID) { result in
            switch result {
            case .success(let teamData):
                completion(teamData.hostID == userID)
            case .failure:
                completion(false)
            }
        }
    }
    
    
    func getTeamName() -> String {
        return localRepository.getTeamName()
    }
    
    func getTeamCode() -> String {
        return localRepository.getTeamCode()
    }
    
    func getUserID() -> String {
        return localRepository.getUserID()
    }
    
    func getUserName() -> String {
        return localRepository.getUserName()
    }
    
    // MARK: - Team 나가기 및 지우기
    func leaveTeam() {
        let userID = localRepository.getUserID()
        let teamCode = localRepository.getTeamCode()
        
        
        firebaseRepository.removeListenersForUserAppData()
        appTrackingUseCase.resetAppTrackings()
        appTrackingUseCase.stopAppTracking()
        firebaseRepository.removeTeamListener()
        firebaseRepository.removeUser(userID: userID, teamCode: teamCode)
        localRepository.resetTeamCode()
        localRepository.resetTeamName()
    }
    
    func deleteTeam() {
        let teamCode = localRepository.getTeamCode()
        firebaseRepository.removeAllUsersInTeam(teamCode: teamCode)
        appTrackingUseCase.stopAppTracking()
    }
    
    func listenToDisbandStatus(teamCode: String, onDisbandStatusChange: @escaping (String) -> Void) {
        firebaseRepository.setUpListenerForTeamData(teamCode: teamCode) { result in
            switch result {
            case .success(let teamData):
                onDisbandStatusChange(teamData.isDisband)
            case .failure(let error):
                print("데이터 수신 중 오류 발생: \(error)")
            }
        }
    }
    
    func changeToDisbandStatus(teamCode: String) {
        firebaseRepository.changeDisbandStatus(teamCode: teamCode)
    }
}

