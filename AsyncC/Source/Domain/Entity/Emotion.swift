//
//  Emotion.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/6/24.
//

import Foundation

struct Emotion {
    var receiver: String // 받는이 UUID
    var emotion: emotionOption?
    var sender: String //보낸이 UUID
    
    enum emotionOption {
        case getHelp
        case giveHelp
        case yes
        case no
    }
}

