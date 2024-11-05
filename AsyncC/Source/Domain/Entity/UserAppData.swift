//
//  UserAppData.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/6/24.
//

import Foundation

struct UserAppData { // Write: user 본인꺼만 write 가능, Read: 모든 user
    let userID: String //UUID
    var appData: [(String, String)] // (앱 이름, 타임스탬프), 타임스탬프는 로컬에서 연산 필요
}
