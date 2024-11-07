//
//  LocalRepository.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

import SwiftUI

final class LocalRepository: LocalRepositoryProtocol {
    @AppStorage("userID") var userID: String = "mia"
    @AppStorage("teamCode") var teamCode: String = ""
    
    func getUserID() -> String {
        return userID
    }
    
    func saveUserID(_ inputID: String) {
        self.userID = inputID
    }
    
    func saveTeamCode(_ inputTeamCode: String) {
        teamCode = inputTeamCode
    }
    
    func getTeamCode() -> String {
        return teamCode
    }
    
}
