//
//  EmoticonUseCase.swift
//  AsyncC
//
//  Created by Jin Lee on 11/8/24.
//

import Foundation

final class EmoticonUseCase {
    private let firebaseRepository: FirebaseRepository
    private let localRepository: LocalRepository
    
    init(localRepo: LocalRepository, firebaseRepo: FirebaseRepository) {
        self.localRepository = localRepo
        self.firebaseRepository = firebaseRepo
    }
    
    func send(emoticon: Emoticon.emoticonOption, receiver: String) {
        let sender = localRepository.getUserID()
        firebaseRepository.sendEmoticon(sender: sender, emoticon: emoticon.rawValue, receiver: receiver)
    }
    
    func setUpListenerForEmoticons(userID: String) {
        firebaseRepository.setUpListenerForEmoticons(userID: userID) { result in
            print(result)
        }
    }
}
