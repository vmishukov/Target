//
//  Tracker.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 18.01.2024.
//

import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let isHabbit: Bool
    let isPinned: Bool
    let schedule: [Weekday]
}
