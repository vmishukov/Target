//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 30.01.2024.
//

protocol ScheduleViewControllerDelegate: AnyObject {
    func getSelectedDays(schedule: [Weekday])
}
