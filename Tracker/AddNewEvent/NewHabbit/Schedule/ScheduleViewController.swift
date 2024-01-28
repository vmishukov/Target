//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 26.01.2024.
//

import UIKit

final class ScheduleViewController : UIViewController {
    
    // MARK: - UI ELEMENTS
    private lazy var scheduleTitle: UILabel = {
        let scheduleTitle = UILabel()
        scheduleTitle.text = "Расписание"
        scheduleTitle.textColor = UIColor(hex: "1A1B22")
        scheduleTitle.font = .systemFont(ofSize: 16, weight: .medium)
        
        view.addSubview(scheduleTitle)
        scheduleTitle.translatesAutoresizingMaskIntoConstraints = false
        self.scheduleTitle = scheduleTitle
        return scheduleTitle
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .system) as UIButton
        doneButton.backgroundColor = .ypBlack
        doneButton.setTitle("Готово", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.setTitleColor(.ypWhite, for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = 16
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        view.addSubview(doneButton)
        self.doneButton = doneButton
        return doneButton
    }()
    
    private lazy var scheduleTableView: UITableView = {
        var scheduleTableView = UITableView(frame: .zero)
        scheduleTableView.register(ScheduleSettingCell.self, forCellReuseIdentifier: ScheduleSettingCell.cellIdentifer)
       
        scheduleTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        scheduleTableView.layer.masksToBounds = true
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        self.scheduleTableView = scheduleTableView
        view.addSubview(scheduleTableView)
        return scheduleTableView
    }()
    
    // MARK: - view
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        scheduleTitleLayout()
        doneButtonLayout()
        scheduleTableViewLayout()
        super.viewDidLoad()
    }
    // MARK: - LAYOUT
    private func scheduleTitleLayout() {
        NSLayoutConstraint.activate([
            scheduleTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scheduleTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func doneButtonLayout() {
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func scheduleTableViewLayout() {
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: scheduleTitle.bottomAnchor, constant: 30),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47)
        ])
    }
    // MARK: - OBJC
    @objc func didTapDoneButton() {
        
    }
}
// MARK: - UITableViewDataSource
extension ScheduleViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleSettingCell.cellIdentifer, for: indexPath) as? ScheduleSettingCell else {
            assertionFailure("Не удалось создать ячейку дня недели ScheduleSettingCell")
            return UITableViewCell()
        }
        cell.textLabel?.text = Weekday.allCases[indexPath.row].rawValue
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            cell.clipsToBounds = true
        }
        
        if indexPath.row ==  Weekday.allCases.count - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
           
            cell.clipsToBounds = true
        }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension ScheduleViewController : UITableViewDelegate {
}
