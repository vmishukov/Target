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
        addTrackerLabel.textColor = .ypBlack
        addTrackerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(addTrackerLabel)
        addTrackerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addTrackerLabel = addTrackerLabel
        return addTrackerLabel
    }()
    
    private lazy var addHabbitButton: UIButton = {
        let addHabbitButton = UIButton(type: .system) as UIButton
        addHabbitButton.backgroundColor = .ypBlack
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
        addIrregularEventButton.backgroundColor = .ypBlack
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

    //MARK: - view func
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        layoutAddTrackerLabel()
        layoutAddHabbitButton()
        layoutAddIrregularEventButton()
        super.viewDidLoad()
    }
    
    //MARK: - Layout
    private func layoutAddTrackerLabel() {
        NSLayoutConstraint.activate([
            addTrackerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTrackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func layoutAddHabbitButton() {
        NSLayoutConstraint.activate([
            addHabbitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            addHabbitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addHabbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addHabbitButton.heightAnchor.constraint(equalToConstant: 60)
        
        ])
    }
    
    private func layoutAddIrregularEventButton() {
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
        present(view, animated: true)
    }
    
    @objc private func didTabAddIrregularEventButton(_ sender: UIButton) {
        let view = NewIrregularEventViewController()
        view.addTrackerDelegate = self
        present(view, animated: true)
    }
}
//MARK: - AddTrackersViewControllerDelegate
extension AddTrackersViewController: AddTrackersViewControllerDelegate {
    func addNewTracker(tracker: Tracker, categoryTitle: String) {
        trackerViewdelegate?.addNewTracker(tracker: tracker, categoryTitle: categoryTitle)
    }
}
