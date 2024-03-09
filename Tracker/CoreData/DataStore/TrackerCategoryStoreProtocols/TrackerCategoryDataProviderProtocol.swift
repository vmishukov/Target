//
//  TrackerCategoryProtocol.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 09.03.2024.
//

import Foundation

protocol TrackerCategoryDataProviderProtocol {
    func fetchCategoryNames() throws -> [String] 
    func addNewTrackerCategory(_ categoryTitle: String) throws
}
