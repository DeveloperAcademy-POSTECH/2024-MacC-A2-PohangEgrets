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
}
