//
//  TrackerDataProviderDelegate.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 25.02.2024.
//

import Foundation
protocol TrackerDataProviderDelegate: AnyObject {
    func trackerStoreDidChange()
}
