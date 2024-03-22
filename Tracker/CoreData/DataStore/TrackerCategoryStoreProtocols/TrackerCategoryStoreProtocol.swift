//
//  TrackerCategoryStoreProtocol.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 09.03.2024.
//

import Foundation

protocol TrackerCategoryStoreProtocol {
    
    func fetchTrackerCategories() throws -> [TrackerCategory]?

    func deleteRequest()
}
