//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Vladislav Mishukov on 16.03.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker


final class TrackerTests: XCTestCase {

    func testLigthTrackersViewController() throws {
        let vc = TrackersViewController()
        assertSnapshot(
            matching: vc,
            as: .image(
                traits: .init(
                    userInterfaceStyle: .light
                )
            )
        )
    }
    
    func testDarkTrackersViewController() throws {
        let vc = TrackersViewController()
        assertSnapshot(
            matching: vc,
            as: .image(
                traits: .init(
                    userInterfaceStyle: .dark
                )
            )
        )
    }

}
