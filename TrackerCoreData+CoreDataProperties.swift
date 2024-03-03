//
//  TrackerCoreData+CoreDataProperties.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 24.02.2024.
//
//

import Foundation
import CoreData


extension TrackerCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
        return NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    }

    @NSManaged public var color: NSObject?
    @NSManaged public var emoji: String?
    @NSManaged public var isHabbit: Bool
    @NSManaged public var schedule: NSObject?
    @NSManaged public var title: String?
    @NSManaged public var tracker_id: UUID?
    @NSManaged public var category: TrackerCategoryCoreData?
    @NSManaged public var record: NSSet?

}

// MARK: Generated accessors for record
extension TrackerCoreData {

    @objc(addRecordObject:)
    @NSManaged public func addToRecord(_ value: TrackerRecordCoreData)

    @objc(removeRecordObject:)
    @NSManaged public func removeFromRecord(_ value: TrackerRecordCoreData)

    @objc(addRecord:)
    @NSManaged public func addToRecord(_ values: NSSet)

    @objc(removeRecord:)
    @NSManaged public func removeFromRecord(_ values: NSSet)

}

extension TrackerCoreData : Identifiable {

}
