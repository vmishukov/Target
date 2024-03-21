//
//  EditHabbitViewModelProtocol.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 13.03.2024.
//

import Foundation
import UIKit

protocol EditHabbitViewModelProtocol {
    var schedule: [Weekday]? { get set }
    
    var selectedEmoji: String? { get set }
    var selectedColor: UIColor? { get set }
    var selectedTitle: String? { get set }
    
    var categoryName: String? { get set }
    var emojiArray: [String] { get }
    var sectionColors: [UIColor] { get }
    
    func edtiTracker()
}
