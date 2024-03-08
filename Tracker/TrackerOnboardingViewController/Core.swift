//
//  Core.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 08.03.2024.
//

import Foundation

class Core{
    
    static let shared = Core()
    
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func notNewUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
