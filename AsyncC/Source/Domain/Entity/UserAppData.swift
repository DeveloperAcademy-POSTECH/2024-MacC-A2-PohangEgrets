//
//  UserAppData.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/6/24.
//

import Foundation

struct UserAppData { // Write: user 본인꺼만 write 가능, Read: 모든 user
    let userID: String //UUID
    var appData: [(String, Int)] // (앱 이름, Epoch time), Epoch time 이란? 1970년 1월1일 부터 흐른 seconds (IT에서 자주 쓰이는 시간 측정 방법)
}
