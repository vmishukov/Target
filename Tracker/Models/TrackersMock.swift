//
//  TrackersMock.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 28.01.2024.
//

import Foundation

struct TrackersMock {
    static var trackersMock: [TrackerCategory] = [
        TrackerCategory(title: "Домашний уют",
                        trackers: [
                            Tracker(id: UUID(),
                                    title: "Полить растения",
                                    color: .ypColorSelection7,
                                    emoji: "😪",
                                    schedule: [.Monday, .Tuesday, .Friday, .Sunday]),
                            Tracker(id: UUID(),
                                    title: "Уборка",
                                    color: .ypBlue,
                                    emoji: "😱",
                                    schedule: [.Saturday])
                        ]),
        TrackerCategory(title: "Здоровье",
                        trackers: [
                            Tracker(id: UUID(),
                                    title: "Выпить таблетки",
                                    color: .ypColorSelection3,
                                    emoji: "😻",
                                    schedule: [.Wednesday, .Thursday, .Saturday])
                        ])
    ]
}
