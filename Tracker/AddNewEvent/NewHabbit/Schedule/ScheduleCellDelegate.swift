//
//  ScheduleCellDelegate.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 01.02.2024.
//

protocol ScheduleCellDelegate: AnyObject {
    func getSelectedDay(day: Weekday)
    func removeSelectedDay(day: Weekday)
}
