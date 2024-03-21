//
//  TrackerOnboardingViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 03.03.2024.
//

import Foundation
import UIKit

final class OnboardingPageController: UIPageViewController  {
    
// MARK: - UI
    lazy var pages: [UIViewController] = {
        let first = TrackerOnboardingViewController()
        let firstPic = UIImage(named: "OnboardingBackground1")
        let firstTitle = NSLocalizedString("onboarding.view.first", comment: "")
        first.initialize(setBackgroundPic: firstPic ?? UIImage(), setTitle: firstTitle)
    
        let second = TrackerOnboardingViewController()
        let secondPic = UIImage(named: "OnboardingBackground2")
        let secondTitle = NSLocalizedString("onboarding.view.second", comment: "")
        second.initialize(setBackgroundPic: secondPic ?? UIImage(), setTitle: secondTitle)
        
        return [first, second]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "1A1B22")
        pageControl.pageIndicatorTintColor = .ypGray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(pageControl)
        return pageControl
    }()
    
    
    private lazy var onboardingButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.backgroundColor = UIColor(hex: "1A1B22")
        button.setTitle(NSLocalizedString("onboarding.button", comment: ""), for: .normal)
        button.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapOnboardingButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        constraitsOnboardingButton()
        constraitsPageControl()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
    
//MARK: - CONSTRAITS
    private func constraitsOnboardingButton() {
        NSLayoutConstraint.activate([
            onboardingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            onboardingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            onboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60)

        ])
    }
    
    private func constraitsPageControl() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -24)
        ])
    }
    
//MARK: - OBJC
    @objc private func didTapOnboardingButton(_ sender: UIButton) {
        UserSettingsStorage.shared.notNewUser()
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.rootViewController = TabBarViewController()
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.1
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
        
        })
    }
    
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingPageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingPageController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
