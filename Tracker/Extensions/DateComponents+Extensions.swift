//
//  DateComponents+Extensions.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 05.02.2024.
//

import Foundation

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }
}
