//
//  EditHabbitViewModel.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 13.03.2024.
//

import Foundation
import UIKit

final class EditHabbitViewModel: EditHabbitViewModelProtocol {
    // MARK: - public variable
    var schedule: [Weekday]? {
        didSet {
            isHabbit = true
        }
    }
    var selectedEmoji: String?
    var selectedColor: UIColor?
    var categoryName: String?
    var selectedTitle: String?
    
    let emojiArray = Constants.emojiArray
    let sectionColors = Constants.sectionColors
    //MARK: - PRIVATE
   
    private var dataProvider: TrackerStoreDataProviderProtocol?
    private var isHabbit: Bool = true
    private let trackerId: UUID

    
    init(trackerId: UUID) {
        self.trackerId = trackerId
        dataProvider = TrackerStore()
        fetchTracker(trackerId: trackerId)
    }
    
    //MARK: - PUBLIC FUNC
    func edtiTracker() {
        guard  let title = selectedTitle, let color = selectedColor, let emoji = selectedEmoji, let schedule = schedule, let categoryName = categoryName else { return }
        
        let tracker = Tracker(id: trackerId, title: title, color: color, emoji: emoji, isHabbit: isHabbit, schedule: schedule)
        do {
            try dataProvider?.edtiTracker(tracker, categoryName: categoryName)
        }
        catch {
            assertionFailure("\(error)")
        }
    }
    //MARK: - PRIVATE FUNC
    private func fetchTracker(trackerId: UUID) {
        do {
            let tracker = try dataProvider?.fetchTracker(uuid: trackerId)
       
            selectedEmoji = tracker?.emoji
            selectedColor = tracker?.color
            selectedTitle = tracker?.title
            schedule = tracker?.schedule
            isHabbit = ((tracker?.isHabbit) != nil)
            let categoryName = try dataProvider?.fetchTrackersCategoryName(uuid: trackerId)
            self.categoryName = categoryName
        }
        catch{
            assertionFailure("\(error)")
        }
    }
}
