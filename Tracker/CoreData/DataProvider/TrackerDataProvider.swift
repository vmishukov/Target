//
//  TrackerDataProvider.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 25.02.2024.
//

import Foundation
import CoreData
import UIKit


final class TrackerDataProvider: NSObject {
    //MARK: - ERRORS
    enum DataProviderError: Error {
        case failedToInitializeContext
    }
    //MARK: - DELEGATE
    weak var delegate: TrackerDataProviderDelegate?
    //MARK: - STORES
    private let trackerStore: TrackerStore?
    private let trackerCategoryStore: TrackerCategoryStore?
    private let trackerRecordStore: TrackerRecordStore?
    //MARK: - PRIVATE
    private let context: NSManagedObjectContext
    
    //MARK: - TRACKER FETCH RESULT CONTROLLER
    private var trackerCategoryFetchedResultsController: NSFetchedResultsController<TrackerCoreData>?

    init (delegate: TrackerDataProviderDelegate) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.context = context
        self.trackerStore = TrackerStore()
        self.trackerCategoryStore = TrackerCategoryStore()
        self.trackerRecordStore = TrackerRecordStore()

        super.init()
        FetchedResultsControllerSetup()
        self.delegate = delegate
    }
    
    private func FetchedResultsControllerSetup() {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        let context = self.context
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        self.trackerCategoryFetchedResultsController = fetchedResultController
    }
}
// MARK: - TrackerDataProviderProtocol
extension TrackerDataProvider:TrackerDataProviderProtocol {
    func addNewTracker(_ tracker: Tracker, trackerCategoryName: String) {
        do {
            try trackerStore?.addNewTracker(tracker, trackerCategoryName: trackerCategoryName)
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) {
        do {
            try trackerCategoryStore?.addNewTrackerCategory(trackerCategory)
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    func fetchTrackerCategories() -> [TrackerCategory]? {
        do {
             return try trackerCategoryStore?.fetchTrackerCategories()
        } catch {
            assertionFailure("\(error)")
        }
        return nil
    }
    
    func addNewTrackerRecord(_ date: Date, _ trackerUUID: UUID) {
        do {
            try trackerRecordStore?.addNewTrackerRecord(date, trackerUUID)
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    func removeRecord(_ trackerId: UUID, date: Date) {
        do {
            try trackerRecordStore?.removeRecord(trackerId, date: date)
        }catch {
            assertionFailure("\(error)")
        }
    }
    
    func fetchTrackerRecord() -> [TrackerRecord]? {
        do {
            return try trackerRecordStore?.fetchTrackerRecord()
        } catch {
            assertionFailure("\(error)")
        }
        return nil
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerStoreDidChange()
    }
}