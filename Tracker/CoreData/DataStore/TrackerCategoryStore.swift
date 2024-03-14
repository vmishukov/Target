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
   private let context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - FETCH CATEGORIES

    private func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        let trackers = try? fetchTrackersCoreDataFromTrackerCategory(title: title)
        
        return TrackerCategory(title: title, trackers: trackers ?? [])
    }
    
    private func fetchTrackersCoreDataFromTrackerCategory(title: String)throws -> [Tracker]? {
        let request = TrackerCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "%K.%K == %@",
                                        #keyPath(TrackerCoreData.category),
                                        #keyPath(TrackerCategoryCoreData.title),
                                        title)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        
        let trackersCoreData = try context.fetch(request)
        return try trackersCoreData.map{ try self.tracker(trackerCoreData: $0) }
    }
    
    private func tracker(trackerCoreData: TrackerCoreData) throws -> Tracker {
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
        let isPinned = trackerCoreData.isPinned
        print(trackerCoreData.color as Any)
        guard let color = trackerCoreData.color as? UIColor else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackerColor
        }
        guard let schedule = trackerCoreData.schedule as? [Weekday] else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackerSchedule
        }
        
        return Tracker(id: tracker_id, title: title, color: color, emoji: emoji, isHabbit: isHabbit, isPinned: isPinned, schedule: schedule)
    }
    
    
}

//MARK: - TrackerCategoryStoreProtocol
extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    
    func fetchTrackerCategories() throws -> [TrackerCategory]? {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        let trackerCategoryFromCoreData = try context.fetch(fetchRequest)
        return try trackerCategoryFromCoreData.map{ try self.trackerCategory(from: $0)}
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

}

//MARK: - TrackerCategoryDataProviderProtocol
extension TrackerCategoryStore: TrackerCategoryDataProviderProtocol {
    func fetchCategoryNames() throws -> [String]  {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let trackerCategoryFromCoreData = try context.fetch(fetchRequest)
        let categoryNames: [String]? = trackerCategoryFromCoreData.map { $0.title ?? "ErrorTitle"}
        return categoryNames ?? []
    }
    
    func addNewTrackerCategory(_ categoryTitle: String) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = categoryTitle
        try context.save()
    }
}
