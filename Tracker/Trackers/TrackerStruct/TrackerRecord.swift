//
//  File.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 18.01.2024.
//

import Foundation

struct TrackerRecord {
    let id: UUID
    let date: Date
    
    
    init(Id: UUID, date: Date) {
        self.id = Id
        self.date = date
    }
}
