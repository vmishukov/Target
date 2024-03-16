//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 08.03.2024.
//

import Foundation

final class TrackersViewModel {
// MARK: - Private
    private var datePickerDate: Date
    private var filterText: String? = nil
    
    private var dataProvider: TrackerDataProviderProtocol?
    private var categories: [TrackerCategory] = []
    
    private(set) var visibleCategories: [TrackerCategory] = [] {
        didSet {
            visibleCategoriesBinding?(visibleCategories)
        }
    }
    
    private(set) var stubStatus: Bool = false {
        didSet {
            stubStatusBinding?(stubStatus)
        }
    }
    
    private(set) var completedTrackers: [TrackerRecord] = []
    private let model = TrackersModel()
    
    // MARK: - Binding
    var visibleCategoriesBinding: Binding<[TrackerCategory]>?
    var stubStatusBinding: Binding<Bool>?
    // MARK: - init
    init(date: Date) {
        self.datePickerDate = date
        self.dataProvider = TrackerDataProvider(delegate: self)
        
        reloadTrackerRecords()
        setCategoriesFromDataProvider()
    }
    // MARK: - public func
    
    func changePinStatus(trackerId: UUID) {
        dataProvider?.changePinStatus(trackerId: trackerId)
    }
    
    func removeTracker(trackerId: UUID) {
        dataProvider?.removeTracker(trackerId)
    }
    
    func setFilterText(filterString: String?) {
        self.filterText = filterString
        reloadVisibleTrackers()
    }
    
    func setFilterDate(filterDate: Date) {
        self.datePickerDate = filterDate
        reloadVisibleTrackers()
    }
    
    func addCompleteDay(id: UUID) {
        let trackerCompleteDAY = TrackerRecord(Id: id, date: datePickerDate)
        if completedTrackers.contains(where: {record in record.id == trackerCompleteDAY.id && record.date.onlyDate == trackerCompleteDAY.date.onlyDate
        }) {
            if let index = completedTrackers.firstIndex(where: {record in record.id == trackerCompleteDAY.id && record.date.onlyDate == trackerCompleteDAY.date.onlyDate
            }) {
                self.dataProvider?.removeRecord(completedTrackers[index].id, date: completedTrackers[index].date)
            }
        }
        else if(Date().onlyDate >= datePickerDate.onlyDate) {
            self.dataProvider?.addNewTrackerRecord(trackerCompleteDAY.date, trackerCompleteDAY.id)
        }
        reloadTrackerRecords()
    }
    
    
    // MARK: - private func
    private func getCategoriesFromDataProvider() -> [TrackerCategory]? {
        guard let newCategories = dataProvider?.fetchTrackerCategories() else{
            return nil
        }
        return newCategories
    }
    
    private func setCategoriesFromDataProvider() {
        if let newCategories = getCategoriesFromDataProvider() {
            self.categories = newCategories
            reloadVisibleTrackers()
        }
    }
    
    private func isStubVisible() {
        stubStatus = visibleCategories.count == 0
    }
    
    private func reloadVisibleTrackers() {
         
         self.visibleCategories = model.reloadVisibleTrackers(categories: self.categories, datePickerDate: datePickerDate, filterText: self.filterText, completedTrackers: self.completedTrackers)
         isStubVisible()
     }
    
    private func reloadTrackerRecords() {
        guard let newTrackerRecords = dataProvider?.fetchTrackerRecord() else{
            return
        }
        self.completedTrackers = newTrackerRecords
    }
}

// MARK: - TrackerDataProviderDelegate
extension TrackersViewModel: TrackerDataProviderDelegate {
    func trackerStoreDidChange() {
        setCategoriesFromDataProvider()
    }
}

// MARK: - AddTrackersViewControllerDelegate
extension TrackersViewModel: AddTrackersViewControllerDelegate {
    func addNewTracker(tracker: Tracker, categoryTitle: String) {
        self.dataProvider?.addNewTracker(tracker, trackerCategoryName: categoryTitle)
    }
}
