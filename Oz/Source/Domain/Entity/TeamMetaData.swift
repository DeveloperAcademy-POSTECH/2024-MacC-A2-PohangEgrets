//
//  TeamMetaData.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/6/24.
//

import Foundation

struct TeamMetaData { // Write: 모든 User firebase .arrayUnion 사용하면 충돌 안남
    var memberIDs: [String] //UUID
    let teamName: String
    let inviteCode: String
    let hostID: String
    var isDisband: String
}

