//
//  SyncRequestNotificationViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/25/24.
//

import SwiftUI

class SyncRequestNotificationViewModel {
//    @EnvironmentObject var router: Router
    var router: Router?
    
    func acceptSyncRequest(to receiverID: String) {
        router?.syncUseCase.send(emoticon: .acceptedSyncRequest, receiver: receiverID)
        router?.showSyncingView()
    }
    
}
