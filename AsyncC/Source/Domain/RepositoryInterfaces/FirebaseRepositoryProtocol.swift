//
//  FirebaseRepositoryProtocol.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/6/24.
//

protocol FirebaseRepositoryProtocol {
    
    func setUserAppData(id: String,
                     appName: String,
                     epochSeconds: Int) -> Void
    
    func setUsers(id: String,
                  email: String,
                  name: String) -> Void
    
    func sendEmoticon(sender: String,
                      emoticon: String,
                      receiver: String) -> Void
    
    func setUpListenerForUserAppData(userID: String, handler: @escaping (Result<UserAppData, Error>) -> Void)
    
    func setUpListenerForEmoticons(userID: String, handler: @escaping (Result<Emoticon, any Error>) -> Void)
}
