//
//  TabBarController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 14.01.2024.
//
import UIKit

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configure()
        
        let trackerViewController = TrackersViewController()
        trackerViewController.tabBarItem = UITabBarItem(title: "Трекер",
                                                        image: UIImage(named: "tab_tracker_logo_active"),
                                                        selectedImage: nil)
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика",
                                                          image: UIImage(named: "tab_stat_logo_active"),
                                                          selectedImage: nil)
        
        self.viewControllers = [trackerViewController,statisticViewController]
    }
    
    private func configure() {
        view.backgroundColor = UIColor(hex: "FFFFFF")
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        lineView.backgroundColor = UIColor.init(hex: "AEAFB4")
        self.tabBar.addSubview(lineView)
    }
}
