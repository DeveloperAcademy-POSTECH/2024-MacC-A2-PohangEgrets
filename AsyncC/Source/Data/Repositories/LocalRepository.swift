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
    @AppStorage("teamCode") var teamCode: String = ""
    
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
        return teamCode
    }
    
    func resetTeamCode() {
        teamCode = ""
    }
    
}
