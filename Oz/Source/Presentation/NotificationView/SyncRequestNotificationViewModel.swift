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
    private let faceTimeUseCase: FaceTimeUseCase
//    
//    @Published var senderEmail: String = "" // The sender's email
//    @Published var receiverEmail: String = "" // The receiver's email
    @Published var emailToUserId: [String: String] = [:] // Mapping of emails to user IDs
    @Published var pendingSyncRequest: Bool = false // Indicates if there's a pending sync request
    
    @Published var secondsLeft: Int = 10
    var timer: Timer?
    
    var router: Router?
    
    init(
        teamManagingUseCase: TeamManagingUseCase,
        syncUseCase: SyncUseCase,
        faceTimeUseCase: FaceTimeUseCase
    ) {
        self.teamManagingUseCase = teamManagingUseCase
        self.syncUseCase = syncUseCase
        self.faceTimeUseCase = faceTimeUseCase
    }
    
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
    
    func acceptSyncRequest(to userID: String, sessionID: String) {
        router?.syncUseCase.send(emoticon: .acceptedSyncRequest, receiver: userID, sessionID: sessionID)
        router?.closePendingSyncWindow()
        
        teamManagingUseCase.getUserEmailConvert(userID: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let email):
                    self?.emailToUserId[userID] = email
                    print("Mapped email \(email) to user ID \(userID)")
                    
                    if let email = self?.emailToUserId[userID] {
                        self?.faceTimeUseCase.startFaceTimeCall(with: email)
                    } else {
                        print("Error: User ID \(userID) not found in emailToUserId dictionary.")
                    }
                    
                case .failure(let error):
                    print("Failed to fetch email for userID \(userID): \(error)")
                }
            }
        }

    }
}

