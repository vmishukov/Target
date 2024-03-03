//
//  TrackerRecordCoreData+CoreDataProperties.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 24.02.2024.
//
//

import Foundation
import CoreData


extension TrackerRecordCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var tracker: NSSet?

}

// MARK: Generated accessors for tracker
extension TrackerRecordCoreData {

    @objc(addTrackerObject:)
    @NSManaged public func addToTracker(_ value: TrackerCoreData)

    @objc(removeTrackerObject:)
    @NSManaged public func removeFromTracker(_ value: TrackerCoreData)

    @objc(addTracker:)
    @NSManaged public func addToTracker(_ values: NSSet)

    @objc(removeTracker:)
    @NSManaged public func removeFromTracker(_ values: NSSet)

}

extension TrackerRecordCoreData : Identifiable {

}
