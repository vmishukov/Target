//
//  TrackersModel.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 08.03.2024.
//

import Foundation

final class TrackersModel {
    
    func reloadVisibleTrackers( categories: [TrackerCategory], datePickerDate: Date, filterText: String?, completedTrackers: [TrackerRecord], filterCondition: Filter)  -> [TrackerCategory] {
        
        let calendar = Calendar.current
        let filterDay = calendar.component(.weekday, from: datePickerDate)
        let filterText = (filterText ?? "").lowercased()
        
        var pinniedTrackers: [Tracker] = []
        
        var visibleCategories : [TrackerCategory]  = categories.compactMap{ category in
            let trackers = category.trackers.filter {tracker in
                
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay.calendarDayNumber == filterDay
                } == true
                var irregularEventCondition = true
                
                if tracker.isHabbit == false
                {
                    if completedTrackers.contains(where: { completeTracker in
                        completeTracker.id == tracker.id}) {
                        let inx = completedTrackers.firstIndex{ findTracker in findTracker.id == tracker.id
                        }
                        if completedTrackers[inx!].date.onlyDate ==  datePickerDate.onlyDate {
                            irregularEventCondition = true
                        } else {
                            irregularEventCondition = false
                        }
                    } else {
                        irregularEventCondition = true
                    }
                }
                
                let textCondition = tracker.title.lowercased().contains(filterText) || filterText.isEmpty
                let pinConditions = !tracker.isPinned
                
                let completeFilterCondition = 
                if filterCondition == .CompletedTrackers {
                    if completedTrackers.contains(where: { completeTracker in
                        completeTracker.id == tracker.id &&
                        completeTracker.date.onlyDate == datePickerDate.onlyDate}) {
                        true
                    } else {
                        false
                    }
                } else {
                    true
                }
                
                let notCompleteFilterCondition =
                if filterCondition == .NotCompletedTrackers {
                    if completedTrackers.contains(where: { completeTracker in
                        completeTracker.id != tracker.id &&
                        completeTracker.date.onlyDate != datePickerDate.onlyDate}) {
                        true
                    } else {
                        false
                    }
                } else {
                    true
                }
                
                if tracker.isPinned && dateCondition && textCondition && irregularEventCondition && completeFilterCondition && notCompleteFilterCondition {
                    pinniedTrackers.append(tracker)
                }
                
                return dateCondition && textCondition && irregularEventCondition && pinConditions && completeFilterCondition && notCompleteFilterCondition
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
        let pinnedTrackerCategory = TrackerCategory(title: NSLocalizedString( "trackers.pinned.category", comment: ""), trackers: pinniedTrackers)
        if pinnedTrackerCategory.trackers.count > 0 {
            visibleCategories.insert(pinnedTrackerCategory, at: 0)
        }
        
        return visibleCategories
    }
    
}
