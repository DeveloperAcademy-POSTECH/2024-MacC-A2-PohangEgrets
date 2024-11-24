//
//  Emotion.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/6/24.
//

import Foundation

struct SyncRequest {
    var sender: String //보낸이 UUID
    var receiver: String // 받는이 UUID
    var syncMessage: SyncMessageOption
    let timestamp: Date
    var isAcknowledged: Bool = false
    
    enum SyncMessageOption: String {
        case syncRequest
        case acceptedSyncRequest
    }
}

