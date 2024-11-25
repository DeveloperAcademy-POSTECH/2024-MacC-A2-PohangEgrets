//
//  SyncRequestNotificationViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/25/24.
//

import SwiftUI

class SyncRequestNotificationViewModel: ObservableObject {
    var router: Router?
    @Published var secondsLeft: Int = 10
    var timer: Timer?
    
    func startTimer(completion: @escaping (() -> Void)) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.secondsLeft > 0 {
                print("timer: \(self.secondsLeft)")
                self.secondsLeft -= 1
            } else {
                print("kill timer")
                timer.invalidate()
                completion()
            }
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
    }
    

    
    func acceptSyncRequest(to receiverID: String) {
        router?.syncUseCase.send(emoticon: .acceptedSyncRequest, receiver: receiverID)
        router?.closePendingSyncWindow()
//        router?.showSyncingLoadingView()
    }
    
}
