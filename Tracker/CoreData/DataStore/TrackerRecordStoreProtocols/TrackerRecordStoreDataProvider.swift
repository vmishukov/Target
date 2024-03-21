//
//  TrackerRecordStoreDataProvider.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 16.03.2024.
//

import Foundation

protocol TrackerRecordStoreDataProvider {
    func fetchRecordCount() throws -> Int?
}
