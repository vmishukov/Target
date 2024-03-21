//
//  FilterTrackers.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 16.03.2024.
//

import Foundation
import UIKit

final class FilterTrackersViewController: UIViewController {
    //MARK: - delegate
    weak var delegate: FilterViewControllerDelegate?
    //MARK: - public
    var selectedFilter: Filter?
    //MARK: - UI
    private lazy var filterTrackerTitle : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("trackers.filter", comment: "")
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.filterTrackerTitle = titleLabel
        return titleLabel
    }()
    
    private lazy var filterTrackerTableView: UITableView = {
        var settingsTableView = UITableView(frame: .zero)
        settingsTableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.cellIdentifer)
        settingsTableView.separatorStyle = .singleLine
        settingsTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        settingsTableView.layer.masksToBounds = true
        settingsTableView.isScrollEnabled = false
        settingsTableView.layer.cornerRadius = 16
        settingsTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        view.addSubview(settingsTableView)
        return settingsTableView
    }()
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        constraitFilterTrackerTitle()
        constraitsFilterTrackerTableView()
        super.viewDidLoad()
    }
    
    //MARK: - CONSTRAITS
    private func constraitFilterTrackerTitle() {
        NSLayoutConstraint.activate([
            filterTrackerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterTrackerTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func constraitsFilterTrackerTableView() {
        NSLayoutConstraint.activate([
            filterTrackerTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filterTrackerTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            filterTrackerTableView.topAnchor.constraint(equalTo: filterTrackerTitle.bottomAnchor, constant: 38),
            filterTrackerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension FilterTrackersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.cellIdentifer, for: indexPath) as? FilterCell else {
            assertionFailure("Не удалось выполнить приведение к SettingsHabitOrEventCell")
            return UITableViewCell()
        }
        
        cell.isCellHidden(true)
        cell.layer.cornerRadius = 0
        cell.layer.maskedCorners = []
        cell.clipsToBounds = false
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        cell.textLabel?.text = "test"
        
        switch indexPath.row {
        case 0:
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            cell.clipsToBounds = true
            cell.textLabel?.text = Filter.AllTrackers.title
            cell.filterCondition = Filter.AllTrackers
        case 1:
            cell.textLabel?.text = Filter.TrackersForToday.title
            cell.filterCondition = Filter.TrackersForToday
        case 2:
            cell.textLabel?.text = Filter.CompletedTrackers.title
            cell.filterCondition = Filter.CompletedTrackers
        case 3:
            cell.textLabel?.text = Filter.NotCompletedTrackers.title
            cell.filterCondition = Filter.NotCompletedTrackers
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 1000)
            
            cell.clipsToBounds = true
        default: ""
        }
        
        if let selectedFilter = self.selectedFilter {
            if selectedFilter == cell.filterCondition {
                //tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                cell.isCellHidden(false)
            }
        }
        
        cell.backgroundColor = .ypBackground
        return cell
    }
}
// MARK: - UITableViewDelegate
extension FilterTrackersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FilterCell {
            cell.isCellHidden(false)
            delegate?.setFilter(filter: cell.filterCondition ?? Filter.AllTrackers)
            self.dismiss(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FilterCell {
            cell.isCellHidden(true)
        }
    }
}
