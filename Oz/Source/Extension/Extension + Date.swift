//
//  Extension + Date.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/27/24.
//

import Foundation

extension Date {
    func isWithinPast(minutes: Int) -> Bool {
        let now = Date.now
        let timeAgo = Date.now.addingTimeInterval(-1 * TimeInterval(60 * minutes))
        let range = timeAgo...now
        return range.contains(self)
    }
}
