//
//  AddTrackersViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 20.01.2024.
//

import Foundation
import UIKit

final class AddTrackersViewController: UIViewController {
    //MARK: - delegate
    weak var trackerViewdelegate: AddTrackersViewControllerDelegate?
    //MARK: - UI ELEMENTS
    private lazy var addTrackerLabel : UILabel = {
        let addTrackerLabel = UILabel()
        addTrackerLabel.text = "Создание трекера"
        addTrackerLabel.textColor = UIColor(hex: "1A1B22")
        addTrackerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(addTrackerLabel)
        addTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addTrackerLabel = addTrackerLabel
        return addTrackerLabel
    }()
    
    private lazy var addHabbitButton: UIButton = {
        let addHabbitButton = UIButton(type: .system) as UIButton
        addHabbitButton.backgroundColor = UIColor(hex: "1A1B22")
        addHabbitButton.setTitle("Привычка", for: .normal)
        addHabbitButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        addHabbitButton.translatesAutoresizingMaskIntoConstraints = false
        addHabbitButton.layer.cornerRadius = 16
        addHabbitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addHabbitButton.addTarget(self, action: #selector(didTabAddHabbitButton), for: .touchUpInside)
        view.addSubview(addHabbitButton)
        self.addHabbitButton = addHabbitButton
        return addHabbitButton
    }()
    
    private lazy var addIrregularEventButton: UIButton = {
        let addIrregularEventButton = UIButton(type: .system) as UIButton
        addIrregularEventButton.backgroundColor = UIColor(hex: "1A1B22")
        addIrregularEventButton.setTitle("Нерегулярные событие", for: .normal)
        addIrregularEventButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        addIrregularEventButton.addTarget(self, action: #selector(didTabAddIrregularEventButton), for: .touchUpInside)
        addIrregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        addIrregularEventButton.layer.cornerRadius = 16
        addIrregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.addSubview(addIrregularEventButton)
        self.addIrregularEventButton = addIrregularEventButton
        return addIrregularEventButton
    }()
    //MARK: - public variable
    var category: [TrackerCategory]?
    //MARK: - view func
    override func viewDidLoad() {
        view.backgroundColor = UIColor(hex: "FFFFFF")
        addTrackerLabelLayout()
        addHabbitButtonLayout()
        addIrregularEventButtonLayout()
        super.viewDidLoad()
    }
    
    //MARK: - Layout
    private func addTrackerLabelLayout() {
        NSLayoutConstraint.activate([
            addTrackerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTrackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func addHabbitButtonLayout() {
        NSLayoutConstraint.activate([
            addHabbitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            addHabbitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addHabbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addHabbitButton.heightAnchor.constraint(equalToConstant: 60)
        
        ])
    }
    
    private func addIrregularEventButtonLayout() {
        NSLayoutConstraint.activate([
            addIrregularEventButton.leadingAnchor.constraint(equalTo: addHabbitButton.leadingAnchor),
            addIrregularEventButton.trailingAnchor.constraint(equalTo: addHabbitButton.trailingAnchor),
            addIrregularEventButton.topAnchor.constraint(equalTo: addHabbitButton.bottomAnchor,constant: +16),
            addIrregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    //MARK: - OBJC
    @objc private func didTabAddHabbitButton(_ sender: UIButton) {
        let view = NewHabbitViewController()
        view.addTrackerDelegate = self
        view.categories = self.category
        present(view, animated: true)
    }
    
    @objc private func didTabAddIrregularEventButton(_ sender: UIButton) {
        let view = NewIrregularEventViewController()
     
        present(view, animated: true)
    }
}

extension AddTrackersViewController: AddTrackersViewControllerDelegate {
    func addNewTracker(trackerCategory: [TrackerCategory]) {
        trackerViewdelegate?.addNewTracker(trackerCategory: trackerCategory)
    }
}
