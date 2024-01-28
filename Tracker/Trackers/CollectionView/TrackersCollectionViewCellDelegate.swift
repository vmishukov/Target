//
//  TrackersCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 28.01.2024.
//

import Foundation

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func addCompleteDay(id: UUID, indexPath: IndexPath)
}
