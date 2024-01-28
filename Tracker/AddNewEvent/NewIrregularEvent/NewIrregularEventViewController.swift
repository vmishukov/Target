//
//  NewIrregularEventViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 26.01.2024.
//

import Foundation

import Foundation
import UIKit

final class NewIrregularEventViewController: UIViewController {
    
    private lazy var NewIrregularEventTitle : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Новое нерегулярное событие"
        titleLabel.textColor = UIColor(hex: "1A1B22")
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.NewIrregularEventTitle = titleLabel
        return titleLabel
    }()
    
    private lazy var newIrregularEventTextField : UITextField = {
        let newIrregularEventTextField = UITextField()
        let paddingViewLeft: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        newIrregularEventTextField.leftView = paddingViewLeft
        newIrregularEventTextField.leftViewMode = .always
        newIrregularEventTextField.layer.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3).cgColor
        newIrregularEventTextField.translatesAutoresizingMaskIntoConstraints = false
        newIrregularEventTextField.placeholder = "Введите название трекера"
        newIrregularEventTextField.layer.cornerRadius = 16
        newIrregularEventTextField.clearButtonMode = .always
        newIrregularEventTextField.addSubview(newIrregularEventLabel)
        view.addSubview(newIrregularEventTextField)
        self.newIrregularEventTextField = newIrregularEventTextField
        self.newIrregularEventTextField.delegate = self
        return newIrregularEventTextField
    }()
    
    private lazy var newIrregularEventLabel : UILabel = {
        let errLabel = UILabel()
        errLabel.text = "Ограничение 38 символов"
        errLabel.font = .systemFont(ofSize: 17)
        errLabel.textColor = UIColor(hex: "F56B6C")
        errLabel.translatesAutoresizingMaskIntoConstraints = false
        errLabel.textAlignment = .center
        errLabel.isHidden = true
        self.newIrregularEventLabel = errLabel
        return errLabel
    }()
    
    private lazy var newIrregularEventSettingsTableView: UITableView = {
        var settingsTableView = UITableView(frame: .zero)
        settingsTableView.register(SettingsHabitOrEventCell.self, forCellReuseIdentifier: SettingsHabitOrEventCell.cellIdentifer)
        settingsTableView.layer.masksToBounds = true
        settingsTableView.layer.cornerRadius = 16
        settingsTableView.separatorStyle = .none
        settingsTableView.isScrollEnabled = false
        settingsTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.newIrregularEventSettingsTableView = settingsTableView
        view.addSubview(settingsTableView)
        return settingsTableView
    }()
    
    private lazy var newIrregularEventCancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.backgroundColor = .ypWhite
        cancelButton.tintColor = .ypRed
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.newIrregularEventCancelButton = cancelButton
        view.addSubview(cancelButton)
        return cancelButton
    }()
    
    private lazy var newIrregularEventCreateButton: UIButton = {
        let createButton = UIButton(type: .system)
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.backgroundColor = .ypGray
        createButton.tintColor = .ypWhite
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        self.newIrregularEventCreateButton = createButton
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
    
        stackView.addArrangedSubview(newIrregularEventCancelButton)
        stackView.addArrangedSubview(newIrregularEventCreateButton)
        self.newHabbbitButtonStackView = stackView
        view.addSubview(stackView)
        return stackView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        newIrregularEventTextFieldLayout()
        newIrregularEventTitleLayout()
        newIrregularEventSettingsTableViewLayout()
        newIrregularEventtButtonsLayout()
        super.viewDidLoad()
    }
    
    private func newIrregularEventTitleLayout() {
        NSLayoutConstraint.activate([
            NewIrregularEventTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NewIrregularEventTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func newIrregularEventTextFieldLayout() {
        NSLayoutConstraint.activate([
            newIrregularEventTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newIrregularEventTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newIrregularEventTextField.topAnchor.constraint(equalTo: NewIrregularEventTitle.bottomAnchor, constant: 38),
            newIrregularEventTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        newIrregularEventErrLabelLayout()
    }
    
    private func newIrregularEventErrLabelLayout() {
        NSLayoutConstraint.activate([
            newIrregularEventLabel.centerXAnchor.constraint(equalTo: newIrregularEventTextField.centerXAnchor),
            newIrregularEventLabel.topAnchor.constraint(equalTo: newIrregularEventTextField.bottomAnchor, constant: 8)
        ])
    }
    
    private func newIrregularEventSettingsTableViewLayout() {
        NSLayoutConstraint.activate([
            newIrregularEventSettingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newIrregularEventSettingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            newIrregularEventSettingsTableView.topAnchor.constraint(equalTo: newIrregularEventTextField.bottomAnchor, constant: 24),
            newIrregularEventSettingsTableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func newIrregularEventtButtonsLayout() {
        NSLayoutConstraint.activate([
            newHabbbitButtonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            newHabbbitButtonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            newHabbbitButtonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            newIrregularEventCreateButton.heightAnchor.constraint(equalToConstant: 60),
            newIrregularEventCancelButton.heightAnchor.constraint(equalToConstant: 60)

        ])
    }
    
    // MARK: - OBJC
    @objc func cancelButtonClicked() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc func createButtonClicked() {
        
    }
}

// MARK: - UITextFieldDelegate
extension NewIrregularEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count ?? 0) +  (string.count - range.length) >= 38 {
            newIrregularEventLabel.isHidden = false
            return false
        }
        newIrregularEventLabel.isHidden = true
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        newIrregularEventLabel.isHidden = true
        return true
    }
}
// MARK: - UITableViewDataSource
extension NewIrregularEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsHabitOrEventCell.cellIdentifer, for: indexPath) as? SettingsHabitOrEventCell else {
            assertionFailure("Не удалось выполнить приведение к SettingsHabitOrEventCell")
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0 :
            cell.textLabel?.text = "Категория"
        default:
            ""
        }
        cell.backgroundColor = .ypBackground
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NewIrregularEventViewController: UITableViewDelegate {
    
}
