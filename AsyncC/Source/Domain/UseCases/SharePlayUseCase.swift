//
//  SharePlayUseCase.swift
//  AsyncC
//
//  Created by ing on 11/25/24.
//

import GroupActivities

// Define the GroupActivity
struct SyncActivity: GroupActivity {
    let sessionID: String // Unique session identifier
    
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = "Sync Collaboration"
        metadata.type = .generic
        //        metadata.preferredBroadcastPolicy = .automatic
        return metadata
    }
}

class SharePlayUseCase {
    private var activeSessions: [String: GroupSession<SyncActivity>] = [:] // Map of sessionID to active sessions
    
    func startSharePlaySession(sessionID: String) async {
        let activity = SyncActivity(sessionID: sessionID)
        do {
            try await activity.activate()
            print("SharePlay session \(sessionID) started successfully!")
        } catch {
            print("Failed to start SharePlay session \(sessionID): \(error.localizedDescription)")
        }
    }
    
    // Observe SharePlay sessions and manage them by sessionID
    func observeSharePlaySessions(handler: @escaping (GroupSession<SyncActivity>) -> Void) {
        Task {
            do {
                for await session in SyncActivity.sessions() {
                    print("Joined a SharePlay session: \(session.activity.sessionID)")
                    activeSessions[session.activity.sessionID] = session
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
    
    // End a specific session by sessionID
    func endSession(sessionID: String) {
        guard let session = activeSessions[sessionID] else {
            print("No active session found for sessionID \(sessionID)")
            return
        }
        session.leave()
        activeSessions.removeValue(forKey: sessionID)
        print("Session \(sessionID) ended.")
    }
}
