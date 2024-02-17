//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 17.02.2024.
//

import Foundation
import CoreData
import UIKit

final class TrackerRecordStore {
    let context: NSManagedObjectContext
    
    
    convenience init () {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        updateTrackerRecord(trackerRecordCoreData, with: trackerRecord)
        try context.save()
    }
    
    
    func updateTrackerRecord(_ trackerRecordCoreData: TrackerRecordCoreData, with trackerRecord: TrackerRecord) {
        trackerRecordCoreData.date = trackerRecord.date // а как дальше
        
    }
}
