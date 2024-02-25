//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 17.02.2024.
//

import Foundation
import CoreData
import UIKit

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTrackersSet
    case decodingErrorInvalidTracker
    case decodingErrorInvalidTrackerSchedule
    case decodingErrorInvalidTrackerColor
}

final class TrackerCategoryStore {
    let context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
//MARK: - ADD CATEGORIES
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        updateTrackerCategory(trackerCategoryCoreData, with: trackerCategory)
        try context.save()
    }
    
    func updateTrackerCategory(_ trackerCategoryCoreData: TrackerCategoryCoreData, with trackerCategory: TrackerCategory) {
        trackerCategoryCoreData.title = trackerCategory.title
    }
//MARK: - FETCH CATEGORIES
    func fetchTrackerCategories() throws -> [TrackerCategory]? {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let trackerCategoryFromCoreData = try context.fetch(fetchRequest)
        return try trackerCategoryFromCoreData.map{ try self.trackerCategory(from: $0)}
    }
    
    func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        let trackers = try? fetchTrackersCoreDataFromTrackerCategory(title: title)
        
        return TrackerCategory(title: title, trackers: trackers ?? [])
    }
    
    func fetchTrackersCoreDataFromTrackerCategory(title: String)throws -> [Tracker]? {
        let request = TrackerCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "%K.%K == %@",
                                        #keyPath(TrackerCoreData.category),
                                        #keyPath(TrackerCategoryCoreData.title),
                                        title)
        
        let trackersCoreData = try context.fetch(request)
        return try trackersCoreData.map{ try self.tracker(trackerCoreData: $0) }
    }
    
    func tracker(trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let tracker_id = trackerCoreData.tracker_id else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTracker
        }
        guard let title = trackerCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTracker
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTracker
        }
        let isHabbit = trackerCoreData.isHabbit
        
        print(trackerCoreData.color as Any)
        guard let color = trackerCoreData.color as? UIColor else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackerColor
        }
        guard let schedule = trackerCoreData.schedule as? [Weekday] else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackerSchedule
        }
        
        return Tracker(id: tracker_id, title: title, color: color, emoji: emoji, isHabbit: isHabbit, schedule: schedule)
    }
    
    func deleteRequest() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TrackerCategoryCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func destroyPersistentStore() {
        guard let firstStoreURL = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator.persistentStores.first?.url else {
            print("Missing first store URL - could not destroy")
            return
        }

        do {
            try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: firstStoreURL, ofType: "TrackerDataModel", options: nil)
        } catch  {
            print("Unable to destroy persistent store: \(error) - \(error.localizedDescription)")
       }
    }
}
//
