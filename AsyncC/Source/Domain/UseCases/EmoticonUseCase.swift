//
//  EmoticonUseCase.swift
//  AsyncC
//
//  Created by Jin Lee on 11/8/24.
//

import Foundation
import AppKit

final class EmoticonUseCase {
    private let firebaseRepository: FirebaseRepositoryProtocol
    private let localRepository: LocalRepositoryProtocol
    
    init(localRepo: LocalRepositoryProtocol, firebaseRepo: FirebaseRepositoryProtocol) {
        self.localRepository = localRepo
        self.firebaseRepository = firebaseRepo
    }
    
    // MARK: - Send Emoticon
    func send(emoticon: Emoticon.emoticonOption, receiver: String) {
        let sender = localRepository.getUserID()
        firebaseRepository.sendEmoticon(sender: sender, emoticon: emoticon.rawValue, receiver: receiver, timestamp: Date.now, isAcknowledged: false)
    }
    
    func setUpListenerForEmoticons(userID: String) {
        firebaseRepository.setUpListenerForEmoticons(userID: userID) { result in
            switch result {
            case .success(let emoticon):
                DispatchQueue.main.async {
                    // Notify HUD to display the emoticon
                    let appDelegate = NSApplication.shared.delegate as? AppDelegate
                    appDelegate?.showEmoticonNotification(sender: emoticon.sender, emoticon: emoticon.emoticon.rawValue)
                }
            case .failure(let error):
                print("Error receiving emoticon: \(error.localizedDescription)")
            }
        }
    }
    
    func acknowledgeEmoticon(receiver: String) {
        firebaseRepository.updateAcknowledgment(for: receiver)
    }
}
