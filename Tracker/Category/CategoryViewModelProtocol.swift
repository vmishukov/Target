//
//  CategoryViewModelProtocol.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 09.03.2024.
//

import Foundation

protocol CategoryViewModelProtocol {
    var categoryNames: [String] { get }
    var visibleCategoriesBinding: Binding<[String]>? { get set }
    
    func addCategory(categoryTitle: String)
}
