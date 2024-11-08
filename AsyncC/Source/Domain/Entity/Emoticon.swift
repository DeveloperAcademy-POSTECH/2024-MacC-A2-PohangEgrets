//
//  Emotion.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/6/24.
//

import Foundation

struct Emoticon {
    var receiver: String // 받는이 UUID
    var emoticon: emoticonOption
    var sender: String //보낸이 UUID
    
    enum emoticonOption: String {
        case getHelp
        case giveHelp
        case yes
        case no
    }
}

