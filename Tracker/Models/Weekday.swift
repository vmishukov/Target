//
//  Weekday.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 26.01.2024.
//

import Foundation

enum Weekday: String, CaseIterable, Codable {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday 
    
    var calendarDayNumber: Int {
        switch self {
        case .Monday:
            return 2
        case .Tuesday:
            return 3
        case .Wednesday:
            return 4
        case .Thursday:
            return 5
        case .Friday:
            return 6
        case .Saturday:
            return 7
        case .Sunday:
            return 1
        }
    }
    
    var title: String {
        switch self {
        case .Monday:
            return NSLocalizedString("weekday.monday", comment: "")
        case .Tuesday:
            return NSLocalizedString("weekday.tuesday", comment: "")
        case .Wednesday:
            return NSLocalizedString("weekday.wednesday", comment: "")
        case .Thursday:
            return NSLocalizedString("weekday.thursday", comment: "")
        case .Friday:
            return NSLocalizedString("weekday.friday", comment: "")
        case .Saturday:
            return NSLocalizedString("weekday.saturday", comment: "")
        case .Sunday:
            return NSLocalizedString("weekday.sunday", comment: "")
        }
    }
    
    var shortDayName: String {
        switch self {
        case .Monday:
            return NSLocalizedString("weekday.monday.short", comment: "")
        case .Tuesday:
            return NSLocalizedString("weekday.tuesday.short", comment: "")
        case .Wednesday:
            return NSLocalizedString("weekday.wednesday.short", comment: "")
        case .Thursday:
            return NSLocalizedString("weekday.thursday.short", comment: "")
        case .Friday:
            return NSLocalizedString("weekday.friday.short", comment: "")
        case .Saturday:
            return NSLocalizedString("weekday.saturday.short", comment: "")
        case .Sunday:
            return NSLocalizedString("weekday.sunday.short", comment: "")
        }
    }}
