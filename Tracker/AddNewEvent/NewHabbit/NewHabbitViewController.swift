//
//  NewHabbitViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 21.01.2024.
//

import Foundation
import UIKit

final class NewHabbitViewController: UIViewController {
    // MARK: - delagate
    weak var addTrackerDelegate: AddTrackersViewControllerDelegate?
    // MARK: - public variable
    var categories: [TrackerCategory]?
    var schedule: [Weekday]?
    // MARK: - UI ELEMENTS
    private lazy var newHabbitTitle : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Новая привычка"
        titleLabel.textColor = UIColor(hex: "1A1B22")
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.newHabbitTitle = titleLabel
        return titleLabel
    }()
    
    private lazy var newHabbitTextField : UITextField = {
        let NewHabbitTextField = UITextField()
        let paddingViewLeft: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        NewHabbitTextField.leftView = paddingViewLeft
        NewHabbitTextField.leftViewMode = .always
        NewHabbitTextField.layer.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3).cgColor
        NewHabbitTextField.translatesAutoresizingMaskIntoConstraints = false
        NewHabbitTextField.placeholder = "Введите название трекера"
        NewHabbitTextField.layer.cornerRadius = 16
        NewHabbitTextField.clearButtonMode = .always
        NewHabbitTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        NewHabbitTextField.addSubview(newHabbitErrLabel)
        view.addSubview(NewHabbitTextField)
        self.newHabbitTextField = NewHabbitTextField
        self.newHabbitTextField.delegate = self
        return NewHabbitTextField
    }()
    
    private lazy var newHabbitErrLabel : UILabel = {
        let errLabel = UILabel()
        errLabel.text = "Ограничение 38 символов"
        errLabel.font = .systemFont(ofSize: 17)
        errLabel.textColor = UIColor(hex: "F56B6C")
        errLabel.translatesAutoresizingMaskIntoConstraints = false
        errLabel.textAlignment = .center
        errLabel.isHidden = true
        self.newHabbitErrLabel = errLabel
        return errLabel
    }()
    
    private lazy var newHabbitSettingsTableView: UITableView = {
        var settingsTableView = UITableView(frame: .zero)
        settingsTableView.register(SettingsHabitOrEventCell.self, forCellReuseIdentifier: SettingsHabitOrEventCell.cellIdentifer)
        settingsTableView.separatorStyle = .singleLine
        settingsTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        settingsTableView.layer.masksToBounds = true
        settingsTableView.isScrollEnabled = false
        settingsTableView.layer.cornerRadius = 16
        settingsTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.newHabbitSettingsTableView = settingsTableView
        view.addSubview(settingsTableView)
        return settingsTableView
    }()
    
    private lazy var newHabbittCancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.backgroundColor = .ypWhite
        cancelButton.tintColor = .ypRed
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.newHabbittCancelButton = cancelButton
        view.addSubview(cancelButton)
        return cancelButton
    }()
    
    private lazy var newHabbitCreateButton: UIButton = {
        let createButton = UIButton(type: .system)
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.backgroundColor = .ypGray
        createButton.tintColor = .ypWhite
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        self.newHabbitCreateButton = createButton
        view.addSubview(createButton)
        return createButton
    }()
    
    private lazy var newHabbbitButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        stackView.addArrangedSubview(newHabbittCancelButton)
        stackView.addArrangedSubview(newHabbitCreateButton)
        self.newHabbbitButtonStackView = stackView
        view.addSubview(stackView)
        return stackView
    }()
    // MARK: - View
    override func viewDidLoad() {
        view.backgroundColor = .white
        newHabbitTextFieldLayout()
        newHabbitTitleLayout()
        newHabbitSettingsTableViewLayout()
        newHabbittButtonsLayout()
        updateButtonStatus()
        super.viewDidLoad()
    }
    // MARK: - Layout
    private func newHabbitTitleLayout() {
        NSLayoutConstraint.activate([
            newHabbitTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newHabbitTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func newHabbitTextFieldLayout() {
        NSLayoutConstraint.activate([
            newHabbitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newHabbitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newHabbitTextField.topAnchor.constraint(equalTo: newHabbitTitle.bottomAnchor, constant: 38),
            newHabbitTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        newHabbitErrLabelLayout()
    }
    
    private func newHabbitErrLabelLayout() {
        NSLayoutConstraint.activate([
            newHabbitErrLabel.centerXAnchor.constraint(equalTo: newHabbitTextField.centerXAnchor),
            newHabbitErrLabel.topAnchor.constraint(equalTo: newHabbitTextField.bottomAnchor, constant: 8)
        ])
    }
    
    private func newHabbitSettingsTableViewLayout() {
        NSLayoutConstraint.activate([
            newHabbitSettingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newHabbitSettingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            newHabbitSettingsTableView.topAnchor.constraint(equalTo: newHabbitTextField.bottomAnchor, constant: 24),
            newHabbitSettingsTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func newHabbittButtonsLayout() {
        NSLayoutConstraint.activate([
            newHabbbitButtonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            newHabbbitButtonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            newHabbbitButtonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            newHabbitCreateButton.heightAnchor.constraint(equalToConstant: 60),
            newHabbittCancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateButtonStatus() {
        if newHabbitTextField.text?.count ?? 0 > 0 && schedule?.count ?? 0 > 0 {
            newHabbitCreateButton.isEnabled = true
            newHabbitCreateButton.backgroundColor = .ypBlack
        } else {
            newHabbitCreateButton.isEnabled = false
            newHabbitCreateButton.backgroundColor = .ypGray
        }
    }
    
    // MARK: - OBJC
    @objc func cancelButtonClicked() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc func createButtonClicked() {
       // category?.remove(at: 1)
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = newHabbitSettingsTableView.cellForRow(at: indexPath)
        guard let categoryTitle = cell?.detailTextLabel?.text , var categories = self.categories, let caption = newHabbitTextField.text, let schedule = self.schedule  else { return }

        let tracker = Tracker(id: UUID(), title: caption, color: .ypColorSelection10, emoji: "🥇", isHabbit: true, schedule: schedule)

        if let index = categories.firstIndex(where: {cat in
            cat.title == categoryTitle
        }) {
            var trackers = categories[index].trackers
            trackers.append(tracker)
            let updatedCategory = TrackerCategory(title: categoryTitle, trackers: trackers)
            categories.remove(at: index)
            categories.insert(updatedCategory, at: index)
        }
        self.addTrackerDelegate?.addNewTracker(trackerCategory: categories)
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateButtonStatus()
    }
}
// MARK: - UITextFieldDelegate
extension NewHabbitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count ?? 0) +  (string.count - range.length) >= 38 {
            newHabbitErrLabel.isHidden = false
            return false
        }
        newHabbitErrLabel.isHidden = true
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {

        newHabbitCreateButton.backgroundColor = .ypGray
        return true
    }

}
// MARK: - UITableViewDataSource
extension NewHabbitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsHabitOrEventCell.cellIdentifer, for: indexPath) as? SettingsHabitOrEventCell else {
            assertionFailure("Не удалось выполнить приведение к SettingsHabitOrEventCell")
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0 :
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = "Домашний уют" //mock
        case 1 :
            cell.textLabel?.text = "Расписание"
        default:
            ""
        }
        cell.backgroundColor = .ypBackground
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NewHabbitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            // TODO
            tableView.deselectRow(at: indexPath, animated: true)
        case 1 :
            let view = ScheduleViewController()
            view.delegate = self
            view.selectedDays = self.schedule
            present(view,animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
    }
}

extension NewHabbitViewController: ScheduleViewControllerDelegate {
    func getSelectedDays(schedule: [Weekday]) {
        self.schedule = schedule
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = newHabbitSettingsTableView.cellForRow(at: indexPath)
        
        if schedule.count == 0 {
            cell?.detailTextLabel?.text = ""
        } else {
            var text: String = ""
            for (idx, element) in schedule.enumerated() {
                if idx == schedule.endIndex-1 {
                    text += element.shortDayName
                } else {
                    text += element.shortDayName + ", "
                }
            }
            cell?.detailTextLabel?.text = text
        }
        updateButtonStatus()
        newHabbitSettingsTableView.reloadData()
    }
}
