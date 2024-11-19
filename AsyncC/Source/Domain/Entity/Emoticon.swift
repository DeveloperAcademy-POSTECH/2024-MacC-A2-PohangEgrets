//
//  Emotion.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/6/24.
//

import Foundation

struct Emoticon {
    var sender: String //보낸이 UUID
    var receiver: String // 받는이 UUID
    var emoticon: emoticonOption
    let timestamp: Date
    var isAcknowledged: Bool = false
    
    enum emoticonOption: String {
        case getHelp = "도움요청"
        case giveHelp = "도움제안"
    }
}

