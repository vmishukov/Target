//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 13.03.2024.
//

import Foundation
protocol TrackerStoreProtocol {
    func addNewTracker(_ tracker: Tracker, trackerCategoryName: String) throws
}
