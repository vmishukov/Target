//
//  TrackerCategoryCoreData+CoreDataProperties.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 24.02.2024.
//
//

import Foundation
import CoreData


extension TrackerCategoryCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCategoryCoreData> {
        return NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
    }

    @NSManaged public var title: String?
    @NSManaged public var traker: NSSet?

}

// MARK: Generated accessors for traker
extension TrackerCategoryCoreData {

    @objc(addTrakerObject:)
    @NSManaged public func addToTraker(_ value: TrackerCoreData)

    @objc(removeTrakerObject:)
    @NSManaged public func removeFromTraker(_ value: TrackerCoreData)

    @objc(addTraker:)
    @NSManaged public func addToTraker(_ values: NSSet)

    @objc(removeTraker:)
    @NSManaged public func removeFromTraker(_ values: NSSet)

}

extension TrackerCategoryCoreData : Identifiable {

}
