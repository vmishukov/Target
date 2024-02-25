//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 17.02.2024.
//

import Foundation
import CoreData
import UIKit

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidDate
    case decodingErrorInvalidTracker
}

final class TrackerRecordStore {
   private let context: NSManagedObjectContext
    
    convenience init () {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
//MARK: - ADD NEW RECORD
    func addNewTrackerRecord(_ date: Date, _ trackerUUID: UUID) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.date = date
        addRecordToTheTracker(trackerRecordCoreData, trackerUUID)
    }
    
    func addRecordToTheTracker(_ record: TrackerRecordCoreData,_  trackerId: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCoreData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(TrackerCoreData.tracker_id),
                                             trackerId as NSUUID)
        do {
            if let results = try context.fetch(fetchRequest) as? [TrackerCoreData] {
                results[0].addToRecord(record)
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
    //MARK: - remove record
    func removeRecord(_ trackerId: UUID, date: Date) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        let trackerRecords = try context.fetch(request)
        let filterRecord = trackerRecords.first {
            $0.tracker?.tracker_id == trackerId && $0.date == date
        }
        
        if let trackerRecordCoreData = filterRecord {
            do {
                context.delete(trackerRecordCoreData)
                try context.save()
            } catch let error as NSError {
                assertionFailure("\(error)")
            }
        }
    }
    
//MARK: - FETCH TRACKER RECORD
    func fetchTrackerRecord() throws -> [TrackerRecord]? {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        let trackerRecordCoreData = try context.fetch(fetchRequest)
        return try trackerRecordCoreData.map{ try self.trackerRecord(from: $0)}
    }
    
    func trackerRecord(from: TrackerRecordCoreData)throws -> TrackerRecord {
        guard let date = from.date else {
            throw TrackerRecordStoreError.decodingErrorInvalidDate
        }
        guard let tracker_id = from.tracker?.tracker_id else {
            throw TrackerRecordStoreError.decodingErrorInvalidTracker
        }
        return TrackerRecord(Id: tracker_id, date: date)
    }
    
    func fetchTrackersFromTrackerRecord(with record: TrackerRecordCoreData) -> UUID? {
        let trackersFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCoreData")
        trackersFetch.returnsObjectsAsFaults = false
        trackersFetch.predicate = NSPredicate(format: "%K == %@",
                                              #keyPath(TrackerCoreData.record),
                                              record)
        do {
            if let results = try context.fetch(trackersFetch) as? [TrackerCoreData] {
                return results.first?.tracker_id
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        return nil
    }
    
    func deleteRequest() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TrackerRecordCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}

