//
//  Date+Extensions.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 28.01.2024.
//

import Foundation

extension Date {
    var onlyDate: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: self)
    }

}

