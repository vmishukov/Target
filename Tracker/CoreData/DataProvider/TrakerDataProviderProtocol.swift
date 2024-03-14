//
//  TrakerDataProviderProtocol.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 25.02.2024.
//

import Foundation

protocol TrackerDataProviderProtocol {
    var delegate: TrackerDataProviderDelegate? { get set }
    
    func addNewTracker(_ tracker: Tracker, trackerCategoryName: String)
  
  //  func addNewTrackerCategory(_ trackerCategory: TrackerCategory)
    func fetchTrackerCategories() -> [TrackerCategory]?
    func destroyPersistentStore()
    func addNewTrackerRecord(_ date: Date, _ trackerUUID: UUID)
    func removeRecord(_ trackerId: UUID, date: Date)
    func fetchTrackerRecord() -> [TrackerRecord]?
    func changePinStatus(trackerId: UUID)
    
}
