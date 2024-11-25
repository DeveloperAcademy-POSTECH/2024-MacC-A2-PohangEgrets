//
//  SharePlayUseCase.swift
//  AsyncC
//
//  Created by ing on 11/25/24.
//

import GroupActivities

// Define the GroupActivity
struct SyncActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = "Sync Collaboration"
        metadata.type = .generic
//        metadata.preferredBroadcastPolicy = .automatic
        return metadata
    }
}

class SharePlaySessionUseCase {
    // Start a new SharePlay session
    func startSharePlaySession() async {
        let activity = SyncActivity()
        do {
            try await activity.activate()
            print("SharePlay session started successfully!")
        } catch {
            print("Failed to start SharePlay session: \(error.localizedDescription)")
        }
    }

    // Observe active SharePlay sessions
    func observeSharePlaySessions(handler: @escaping (GroupSession<SyncActivity>) -> Void) {
        Task {
            do {
                for await session in SyncActivity.sessions() {
                    print("Joined a SharePlay session: \(session)")
                    handler(session)
                }
            } catch {
                print("Error observing SharePlay sessions: \(error.localizedDescription)")
            }
        }
    }

    // Handle session state updates
    func handleSessionState(_ session: GroupSession<SyncActivity>, handler: @escaping (GroupSession<SyncActivity>.State) -> Void) {
        Task {
            for await state in session.$state.values {
                handler(state)
                print("Session state updated: \(state)")
            }
        }
    }

    // End a session
    func endSession(_ session: GroupSession<SyncActivity>) {
        session.leave()
        print("Session ended.")
    }
}
