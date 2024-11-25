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
    var router: Router?
    
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
            case .success(let syncRequest):
                DispatchQueue.main.async {
                    if syncRequest.syncMessage == .syncRequest {
                        self.showSyncRequest(senderName: syncRequest.senderName,
                                             senderID: syncRequest.senderID)
                    } else if syncRequest.syncMessage == .acceptedSyncRequest {
                        print("\(syncRequest.senderName) accepted your sync request")
                        self.showSyncRequestAccepted()
                    }
                }
            case .failure(let error):
                print("Error receiving emoticon: \(error.localizedDescription)")
            }
        }
    }
    
    private func showSyncRequest(senderName: String, senderID: String) {
        guard let router else {return print("Router not found")}
        router.showSyncRequest(senderName: senderName, senderID: senderID)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            router.disappearHUDWindow()
//        }
    }
    
    private func showSyncRequestAccepted() {
        router?.showSyncingView()
    }
    
    func setUpSyncWith(_ senderID: String) {
        
    }
    
}
