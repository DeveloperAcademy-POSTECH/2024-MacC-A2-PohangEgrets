//
//  SyncRequestNotificationViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/25/24.
//

import Foundation


class SyncRequestNotificationViewModel: ObservableObject {
    private let teamManagingUseCase: TeamManagingUseCase
    private let syncUseCase: SyncUseCase
    private let sharePlayUseCase: SharePlayUseCase

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
    

    
    @Published var senderEmail: String = "" // The sender's email
    @Published var receiverEmail: String = "" // The receiver's email
    @Published var emailToUserId: [String: String] = [:] // Mapping of emails to user IDs
    @Published var pendingSyncRequest: Bool = false // Indicates if there's a pending sync request
    
    init(
        teamManagingUseCase: TeamManagingUseCase,
        syncUseCase: SyncUseCase,
        sharePlayUseCase: SharePlayUseCase
    ) {
        self.teamManagingUseCase = teamManagingUseCase
        self.syncUseCase = syncUseCase
        self.sharePlayUseCase = sharePlayUseCase
    }
    
    
    // Fetch and map emails to user IDs
    func populateEmailData(for userIDs: [String]) {
        for userID in userIDs {
            teamManagingUseCase.getUserEmailConvert(userID: userID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let email):
                        self?.emailToUserId[email] = userID
                        print("Mapped email \(email) to user ID \(userID)")
                    case .failure(let error):
                        print("Failed to fetch email for userID \(userID): \(error)")
                    }
                }
            }
        }
    }
    
    
    func acceptSyncRequest(to receiverID: String, sessionID: String) {
        router?.syncUseCase.send(emoticon: .acceptedSyncRequest, receiver: receiverID, sessionID: sessionID)
        router?.closePendingSyncWindow()
        //        router?.showSyncingLoadingView()
        
        Task {
            await sharePlayUseCase.startSharePlaySession(sessionID: sessionID)
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
