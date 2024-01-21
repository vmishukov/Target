//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 15.01.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private lazy var addTrackerButton : UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "button_add_tracker")!,
            target: self,
            action: #selector(self.didTapAddTrackerButton)
        )
        button.tintColor = UIColor(hex: "1A1B22")
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        self.addTrackerButton = button
        return button
    }()
    
    private lazy var trackerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.text = "Трекеры"
        view.addSubview(label)
        return label
    }()
    
    private lazy var trackerDatePicker : UIDatePicker = {
        let trackerDatePicker = UIDatePicker()
        trackerDatePicker.datePickerMode = .date
        trackerDatePicker.preferredDatePickerStyle = .compact
        trackerDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        trackerDatePicker.locale = Locale(identifier: "Russian")
        trackerDatePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackerDatePicker)
        return trackerDatePicker
    }()
    
    private lazy var trackerSearchBar : UISearchBar = {
        let trackerSearchBar = UISearchBar()
        trackerSearchBar.placeholder = "Поиск"
        trackerSearchBar.translatesAutoresizingMaskIntoConstraints = false
        trackerSearchBar.searchBarStyle = .minimal
    
        view.addSubview(trackerSearchBar)
        return trackerSearchBar
    }()
    
    private lazy var trackerErrImage : UIImageView = {
        let trackerErrImage = UIImageView()
        let picture = UIImage(named: "err")
        trackerErrImage.image = picture
        trackerErrImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackerErrImage)
        return trackerErrImage
    }()
    
    private lazy var trackerErrLabel : UILabel = {
        let trackerErrLabel = UILabel()
        trackerErrLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerErrLabel.font = UIFont.systemFont(ofSize: 12)
        trackerErrLabel.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
     
        trackerErrLabel.attributedText = NSMutableAttributedString(string: "Что будем отслеживать?", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        view.addSubview(trackerErrLabel)
        return trackerErrLabel
    }()
    private let ShowAddTrackersSegueIdentifier = "ShowAddTrackers"
    
    var categories: [TrackerCategory]?
    var completeTrackers: [TrackerRecord]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        addTrackerButtonLayout()
        labelTrackerLayout()
        datePickerLayout()
        searchBarLayout()
        errImageLayout()
        errLabelLayout()
    }
    

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    @objc private func didTapAddTrackerButton(_ sender: UIButton) {
        let view = AddTrackersViewController()
     
        present(view, animated: true)
    }
    
    private func addTrackerButtonLayout() {
        NSLayoutConstraint.activate([
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            addTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6)
        ])
    }
    
    private func labelTrackerLayout() {
        NSLayoutConstraint.activate([
            trackerLabel.leadingAnchor.constraint(equalTo: addTrackerButton.leadingAnchor, constant: 10),
            trackerLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 1)
        ])
    }
    
    private func datePickerLayout() {
        NSLayoutConstraint.activate([
            trackerDatePicker.widthAnchor.constraint(equalToConstant: 100),
            trackerDatePicker.heightAnchor.constraint(equalToConstant: 34),
            trackerDatePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            trackerDatePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
        ])
    }
    
    private func searchBarLayout() {
        NSLayoutConstraint.activate([
            trackerSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            trackerSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            trackerSearchBar.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: -9)
        ])
        trackerSearchBar.directionalLayoutMargins = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
    
    private func errImageLayout() {
        NSLayoutConstraint.activate([
            trackerErrImage.widthAnchor.constraint(equalToConstant: 80),
            trackerErrImage.heightAnchor.constraint(equalToConstant: 80),
            trackerErrImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackerErrImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        
        ])
    }
    
    private func errLabelLayout() {
        NSLayoutConstraint.activate([
            trackerErrLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackerErrLabel.topAnchor.constraint(equalTo: trackerErrImage.bottomAnchor, constant: 8)
        
        ])
    }
}
