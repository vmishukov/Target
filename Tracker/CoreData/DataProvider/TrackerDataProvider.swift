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
    private let trackerStore: TrackerStoreProtocol?
    private let trackerCategoryStore: TrackerCategoryStoreProtocol?
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
      //  destroyPersistentStore()
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
    func changePinStatus(trackerId: UUID) {
        do {
            try trackerStore?.changePinStatus(trackerId: trackerId)
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    func addNewTracker(_ tracker: Tracker, trackerCategoryName: String) {
        do {
            try trackerStore?.addNewTracker(tracker, trackerCategoryName: trackerCategoryName)
        } catch {
            assertionFailure("\(error)")
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
