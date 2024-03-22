//
//  Analysis.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 16.03.2024.
////
//
import Foundation
import YandexMobileMetrica

final class Analysis {
    // MARK: - Identifier
    static let shared = Analysis()
    private init() {}
    // MARK: - Public Methods
    func reportEvent(event: String, parameters: [String: String]) {
            YMMYandexMetrica.reportEvent(event, parameters: parameters, onFailure: { error in
                print("REPORT ERROR: %@", error.localizedDescription)
            })
        }
}
