//
//  SyncRequestNotificationViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/25/24.
//

import Foundation


class SyncRequestNotificationViewModel {
    private let sharePlayUseCase = SharePlaySessionUseCase()
    var router: Router?

    func acceptSyncRequest(to receiverID: String) {
        router?.syncUseCase.send(emoticon: .acceptedSyncRequest, receiver: receiverID)
        router?.closePendingSyncWindow()
        router?.showSyncingLoadingView()

        Task {
            await sharePlayUseCase.startSharePlaySession()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.router?.closeSyncingLoadingWindow()
            }
        }
    }

    func observeSessions() {
        sharePlayUseCase.observeSharePlaySessions { session in
            self.sharePlayUseCase.handleSessionState(session) { state in
                switch state {
                case .joined:
                    print("Successfully joined the session!")
                case .invalidated:
                    print("Session ended.")
                default:
                    break
                }
            }
        }
    }
}
