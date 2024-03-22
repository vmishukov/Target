//
//  AppDelegate.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 13.01.2024.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DaysValueTransformer.register() 
        
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "ba925b99-65d8-49cb-85ba-f4879fcf4ea9") else { // используйте ваш ключ
            return true
        }
        YMMYandexMetrica.activate(with: configuration)
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores(completionHandler: {  (storeDescription, error) in
            if let error = error as NSError? {
                
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let contex = persistentContainer.viewContext
        if contex.hasChanges {
            do {
                try contex.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

