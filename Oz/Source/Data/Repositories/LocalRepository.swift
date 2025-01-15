//
//  LocalRepository.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

import SwiftUI

final class LocalRepository: LocalRepositoryProtocol {
    @AppStorage("userID") var userID: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("teamName") var teamName: String = ""
    @AppStorage("teamCode") private var _teamCode: String = ""
    
    var teamCode: String? {
        get {
            _teamCode.isEmpty ? nil : _teamCode
        }
        set {
            _teamCode = newValue ?? ""
        }
    }
    
    func getUserID() -> String {
        return userID
    }
    
    func saveUserID(_ inputID: String) {
        self.userID = inputID
    }
    
    func getUserName() -> String {
        return userName
    }
    
    func saveUserName(_ inputName: String) {
        self.userName = inputName
    }
    
    func saveTeamCode(_ inputTeamCode: String) {
        teamCode = inputTeamCode
    }
    
    func getTeamCode() -> String {
        return teamCode ?? "pocmio"
    }
    
    func resetTeamCode() {
        teamCode = ""
    }
    
    func saveTeamName(_ inputTeamName: String) {
        teamName = inputTeamName
    }
    
    func getTeamName() -> String {
        return teamName
    }
    
    func resetTeamName() {
        teamName = ""
    }
    
    func clearLocalUserData() {
        self.saveUserID("")
        self.saveUserName("")
    }
}

