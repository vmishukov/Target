//
//  NewHabbitViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 21.01.2024.
//

import Foundation
import UIKit

final class NewHabbitViewController: UIViewController {
    
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
        settingsTableView.layer.cornerRadius = 16
        settingsTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.newHabbitSettingsTableView = settingsTableView
        view.addSubview(settingsTableView)
        return settingsTableView
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        newHabbitTextFieldLayout()
        newHabbitTitleLayout()
        newHabbitSettingsTableViewLayout()
        super.viewDidLoad()
    }
    
    private func newHabbitTitleLayout() {
        NSLayoutConstraint.activate([
            newHabbitTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newHabbitTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 13)
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
        newHabbitErrLabel.isHidden = true
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
        cell.textLabel?.text = "ddd"

        cell.backgroundColor = .ypBackground
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NewHabbitViewController: UITableViewDelegate {
    
}
