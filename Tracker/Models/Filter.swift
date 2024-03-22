//
//  Filter.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 16.03.2024.
//

import Foundation

enum Filter: String, CaseIterable   {
    
    case AllTrackers
    case TrackersForToday
    case CompletedTrackers
    case NotCompletedTrackers
    
    var title: String {
        switch self {
        case .AllTrackers:
            return NSLocalizedString("trackers.filter.all.trackers", comment: "")
        case .TrackersForToday:
            return NSLocalizedString("trackers.filter.today.trackers", comment: "")
        case .CompletedTrackers:
            return NSLocalizedString("trackers.filter.сompleted", comment: "")
        case .NotCompletedTrackers:
            return NSLocalizedString("trackers.filter.not.сompleted", comment: "")
        }
    }
}
