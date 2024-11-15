//
//  LocalRepositoryProtocol.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

protocol LocalRepositoryProtocol {
    
    func getUserID() -> String
    
    func saveUserID(_ inputID: String)
    
    func getUserName() -> String
    
    func saveUserName(_ inputName: String)
    
    func saveTeamCode(_ inputTeamCode: String)
    
    func getTeamCode() -> String
    
}
