//
//  NewCategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 09.03.2024.
//

import Foundation

protocol NewCategoryViewControllerDelegate: AnyObject {
    func addNewCategory(categoryName: String)
}
