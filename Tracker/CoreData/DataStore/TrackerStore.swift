//
//  TrackerStore.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 17.02.2024.
//

import Foundation
import CoreData
import UIKit


final class TrackerStore {
    private let context: NSManagedObjectContext
    // MARK: - INIT
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        self.init(context: context)
    }
    init (context: NSManagedObjectContext) {
        self.context = context
    }
    
//MARK: - ADD NEW TRACKER
    func addNewTracker(_ tracker: Tracker, trackerCategoryName: String) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
        addTrackerToTrackerCategory(trackerCategoryName, trackerCoreData)
    }
    
   private func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.tracker_id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.isHabbit = tracker.isHabbit
        trackerCoreData.schedule = tracker.schedule as NSObject
    }
    
   private func addTrackerToTrackerCategory(_ trackerCategoryName: String,_ tracker: TrackerCoreData) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCategoryCoreData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(TrackerCategoryCoreData.title),
                                             trackerCategoryName)
        do {
            if let results = try context.fetch(fetchRequest) as? [TrackerCategoryCoreData] {
                results[0].addToTraker(tracker)
                print(results)
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        do {
            try context.save()
        } catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
    func deleteRequest() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TrackerCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            assertionFailure("\(error)")
        }
    }
}
