//
//  Core.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 08.03.2024.
//


import Foundation

class UserSettingsStorage{
    
    static let shared = UserSettingsStorage()
    private init() {}
    
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "notNewUser")
    }
    
    func notNewUser(){
        UserDefaults.standard.set(true, forKey: "notNewUser")
    }
}
