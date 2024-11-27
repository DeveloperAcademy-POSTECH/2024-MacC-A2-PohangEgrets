//
//  Emotion.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/6/24.
//

import Foundation

struct SyncRequest {
    var senderID: String //보낸이 UUID
    var senderName: String
    
    var receiverID: String // 받는이 UUID
    var syncMessage: SyncMessageOption
    let timestamp: Date
    var isAcknowledged: Bool = false
    var sessionID: String // one-on-one SharePlay Session ID
    
    enum SyncMessageOption: String {
        case syncRequest
        case acceptedSyncRequest
    }
}

