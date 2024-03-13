//
//  TrackerStoreDataProviderProtocol.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 13.03.2024.
//

import Foundation

protocol TrackerStoreDataProviderProtocol {
    func fetchTracker(uuid: UUID) throws -> Tracker?
    func fetchTrackersCategoryName(uuid: UUID) throws -> String?
    
    func edtiTracker(_ tracker: Tracker, categoryName: String) throws
}
