//
//  LocalRepositoryProtocol.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

protocol LocalRepositoryProtocol {
    
    var userID: String { get set }
    var userName: String { get set }
    var teamCode: String? { get set }
    var teamName: String { get set }
    
    func getUserID() -> String
    
    func saveUserID(_ inputID: String)
    
    func getUserName() -> String
    
    func saveUserName(_ inputName: String)
    
    func saveTeamCode(_ inputTeamCode: String)
    
    func saveTeamName(_ inputTeamName: String)
    
    func getTeamCode() -> String
    
    func getTeamName() -> String
    
    func resetTeamCode()
    
    func resetTeamName()
    
    func clearLocalUserData()
}

