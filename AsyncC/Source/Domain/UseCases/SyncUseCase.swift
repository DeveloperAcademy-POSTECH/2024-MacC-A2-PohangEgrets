//
//  EmoticonUseCase.swift
//  AsyncC
//
//  Created by Jin Lee on 11/8/24.
//

import Foundation
import AppKit

final class SyncUseCase {
    private let firebaseRepository: FirebaseRepositoryProtocol
    private let localRepository: LocalRepositoryProtocol
    
    init(localRepo: LocalRepositoryProtocol, firebaseRepo: FirebaseRepositoryProtocol) {
        self.localRepository = localRepo
        self.firebaseRepository = firebaseRepo
    }
    
    // MARK: - Send Emoticon
    func send(emoticon: SyncRequest.SyncMessageOption, receiver: String) {
        let senderID = localRepository.getUserID()
        let senderName = localRepository.getUserName()
        firebaseRepository.sendSyncRequest(senderID: senderID, senderName: senderName, syncRequestType: emoticon.rawValue, receiver: receiver, timestamp: Date.now, isAcknowledged: false)
    }
    
    func setUpListenerForEmoticons(userID: String) {
        firebaseRepository.setupListenerForSyncRequest(userID: userID) { result in
            switch result {
            case .success(let emoticon):
                DispatchQueue.main.async {
                    // Notify HUD to display the emoticon
//                    let appDelegate = NSApplication.shared.delegate as? AppDelegate
//                    appDelegate?.showEmoticonNotification(sender: emoticon.sender, emoticon: emoticon.syncMessage.rawValue)
                }
            case .failure(let error):
                print("Error receiving emoticon: \(error.localizedDescription)")
            }
        }
    }
    
    private func showSyncRequest(from senderID: String) {
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
//        appDelegate?.showEmoticonNotification(sender: emoticon.sender, emoticon: emoticon.syncMessage.rawValue)
    }
    
    private func setUpSyncWith(_ senderID: String) {
        
    }
    
//    func acknowledgeEmoticon(receiver: String) {
//        firebaseRepository.updateAcknowledgment(for: receiver)
//    }
}
