//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 09.03.2024.
//

import Foundation

final class CategoryViewModel: CategoryViewModelProtocol {
    // MARK: - Private
    private var dataProvider: TrackerCategoryDataProviderProtocol?
    private(set) var categoryNames: [String] = [] {
        didSet {
            visibleCategoriesBinding?(categoryNames)
        }
    }
    // MARK: - Binding
    var visibleCategoriesBinding: Binding<[String]>?
    // MARK: - Init
    init() {
        self.dataProvider = TrackerCategoryStore()
        setCategoryNames()
    }
    // MARK: - private func
    private  func setCategoryNames() {
        do {
            if let categoryNames = try dataProvider?.fetchCategoryNames() {
                self.categoryNames = categoryNames
            }
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    // MARK: - public func
    func addCategory(categoryTitle: String) {
        if categoryNames.contains(where: { cat in cat == categoryTitle }) == true  {
            return
        }
        do {
            try dataProvider?.addNewTrackerCategory(categoryTitle)
            setCategoryNames()
        }
        catch {
            assertionFailure("\(error)")
        }
    }
    
}
