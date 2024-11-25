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
    
    func requestForSync(receiver: String){
        send(emoticon: .syncRequest, receiver: receiver)
        firebaseRepository.checkExistUserBy(userID: receiver) { exists, recipientName in
            if exists, let recipientName {
                self.showSyncRequest(recipientName: recipientName, isSender: true)
            }
        }
    }
    
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
                        self.firebaseRepository.checkExistUserBy(userID: userID) { exists, userName in
                            if exists, let userName {
                                self.showSyncRequest(senderName: userName,
                                                     senderID: syncRequest.senderID,
                                                     isSender: false)
                            }
                        }
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
    
    func showSyncRequest(senderName: String = "",
                         senderID: String = "",
                         recipientName: String = "",
                         isSender: Bool) {
        guard let router else {return print("Router not found")}
        router.hideHUDWindow()
        router.showPendingSyncRequest(senderName: senderName,
                                      senderID: senderID,
                                      recipientName: recipientName,
                                      isSender: isSender)
    }
    
    private func showSyncRequestAccepted() {
        print("showing sync request accepted")
//        router?.showSyncingLoadingView()
    }
    
    func setUpSyncWith(_ senderID: String) {
        
    }
    
}