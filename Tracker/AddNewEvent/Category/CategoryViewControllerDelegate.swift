//
//  CategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 09.03.2024.
//

import Foundation

protocol CategoryViewControllerDelegate: AnyObject  {
    func setSelectedCategory(categoryName: String?)
}
