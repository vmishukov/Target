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
    // MARK: - private
    private let newHabbitCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let emojiArray = Constants.emojiArray
    private let sectionColors = Constants.sectionColors
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
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
    
    private lazy var newHabbitScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
 
        self.newHabbitScrollView = scrollView
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.isUserInteractionEnabled = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView = containerView
        return containerView
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
        containerView.addSubview(NewHabbitTextField)
        self.newHabbitTextField = NewHabbitTextField
        self.newHabbitTextField.delegate = self
        return NewHabbitTextField
    }()
    
    private lazy var newHabbitErrLabel : UILabel = {
        let errLabel = UILabel()
        errLabel.text = "Ограничение 38 символов"
        errLabel.font = .systemFont(ofSize: 17)
        errLabel.textColor = .ypRed
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
        containerView.addSubview(settingsTableView)
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
    // MARK: - Life cycle
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        constraitNewHabbitTitle()
        constraitNewHabbitScrollView()
        constraitContainerView()
        constraitNewHabbitTextField()
        emojiCollectionSetup()
        
        constraitNewHabbitSettingsTableView()
        constraitNewHabbittButtons()
        updateButtonStatus()
        cancelKeyboardGestureSetup()

        super.viewDidLoad()
    }
    // MARK: - Private func
    private func cancelKeyboardGestureSetup() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func updateButtonStatus() {
        if newHabbitTextField.text?.count ?? 0 > 0 && schedule?.count ?? 0 > 0 && selectedColor != nil && selectedEmoji != nil {
            newHabbitCreateButton.isEnabled = true
            newHabbitCreateButton.backgroundColor = .ypBlack
        } else {
            newHabbitCreateButton.isEnabled = false
            newHabbitCreateButton.backgroundColor = .ypGray
        }
    }
    
    private func emojiCollectionSetup() {
        newHabbitCollectionView.delegate = self
        newHabbitCollectionView.dataSource = self
        newHabbitCollectionView.isScrollEnabled = false
        newHabbitCollectionView.bounces = false
        newHabbitCollectionView.allowsMultipleSelection = true
        newHabbitCollectionView.register(SettingEmojiCell.self, forCellWithReuseIdentifier: SettingEmojiCell.cellIdentifier)
        newHabbitCollectionView.register(SettingColorCell.self, forCellWithReuseIdentifier: SettingColorCell.cellIdentifier)
        newHabbitCollectionView.register(SettingCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingCollectionHeader.identifier)
        newHabbitCollectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(newHabbitCollectionView)
        constraitEmojiCollection()
    }
    
    // MARK: - constrait
    private func constraitEmojiCollection() {
        NSLayoutConstraint.activate([
            newHabbitCollectionView.topAnchor.constraint(equalTo: newHabbitSettingsTableView.bottomAnchor),
            newHabbitCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            newHabbitCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            newHabbitCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -16),
        
            
        ])
    }
    private func constraitContainerView() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: newHabbitScrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: newHabbitScrollView.leadingAnchor),
            containerView.widthAnchor.constraint(equalTo: newHabbitScrollView.widthAnchor),
            containerView.trailingAnchor.constraint(equalTo: newHabbitScrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: newHabbitScrollView.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: newHabbitScrollView.heightAnchor,constant: 170)
        ])
    }
    private func constraitNewHabbitScrollView() {
        NSLayoutConstraint.activate([
            newHabbitScrollView.topAnchor.constraint(equalTo: newHabbitTitle.bottomAnchor, constant: 38),
            newHabbitScrollView.bottomAnchor.constraint(equalTo: newHabbbitButtonStackView.topAnchor,constant: -16),
            newHabbitScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newHabbitScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    private func constraitNewHabbitTitle() {
        NSLayoutConstraint.activate([
            newHabbitTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newHabbitTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func constraitNewHabbitTextField() {
        NSLayoutConstraint.activate([
            newHabbitTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            newHabbitTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            newHabbitTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            newHabbitTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        constraitNewHabbitErrLabel()
    }
    
    private func constraitNewHabbitErrLabel() {
        NSLayoutConstraint.activate([
            newHabbitErrLabel.centerXAnchor.constraint(equalTo: newHabbitTextField.centerXAnchor),
            newHabbitErrLabel.topAnchor.constraint(equalTo: newHabbitTextField.bottomAnchor, constant: 8)
        ])
    }
    
    private func constraitNewHabbitSettingsTableView() {
        NSLayoutConstraint.activate([
            newHabbitSettingsTableView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newHabbitSettingsTableView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            newHabbitSettingsTableView.topAnchor.constraint(equalTo: newHabbitTextField.bottomAnchor, constant: 24),
            newHabbitSettingsTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func constraitNewHabbittButtons() {
        NSLayoutConstraint.activate([
            newHabbbitButtonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            newHabbbitButtonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            newHabbbitButtonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            newHabbitCreateButton.heightAnchor.constraint(equalToConstant: 60),
            newHabbittCancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - OBJC
    @objc func cancelButtonClicked() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    @objc func hideKeyboard() {
        self.newHabbitTextField.endEditing(true)
    }
    
    @objc func createButtonClicked() {
       // category?.remove(at: 1)
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = newHabbitSettingsTableView.cellForRow(at: indexPath)
        guard let categoryTitle = cell?.detailTextLabel?.text , let caption = newHabbitTextField.text, let schedule = self.schedule, let selectedColor = self.selectedColor, let selectedEmoji = self.selectedEmoji  else { return }

        let tracker = Tracker(id: UUID(), title: caption, color: selectedColor, emoji: selectedEmoji, isHabbit: true, schedule: schedule)
        
        self.addTrackerDelegate?.addNewTracker(tracker: tracker, categoryTitle: categoryTitle)
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateButtonStatus()
    }
}
// MARK: - UICollectionViewDelegate
extension NewHabbitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: true) })
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectedEmoji = emojiArray[indexPath.row]
        } else {
            self.selectedColor = sectionColors[indexPath.row]
        }
        updateButtonStatus()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectedEmoji = nil
        } else {
            self.selectedColor = nil
        }
        updateButtonStatus()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewHabbitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availibleWidth = newHabbitCollectionView.frame.width - 9
        let cellWidth = availibleWidth / CGFloat(7)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize  {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - UICollectionViewDataSource
extension NewHabbitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItemsInSection = section == 0 ? emojiArray.count : sectionColors.count
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingEmojiCell.cellIdentifier, for: indexPath) as? SettingEmojiCell else {return UICollectionViewCell()}
            cell.settingEmojiCell(emoji: emojiArray[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingColorCell.cellIdentifier, for: indexPath) as? SettingColorCell else {return UICollectionViewCell()}
            cell.settingColorCell(color: sectionColors[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingCollectionHeader.identifier, for: indexPath) as! SettingCollectionHeader
        indexPath.section == 0 ? view.settingHeaderSetup(titleText: "Emoji") :  view.settingHeaderSetup(titleText: "Цвет")
        return view
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.newHabbitTextField.resignFirstResponder()
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
            cell.detailTextLabel?.text = "test" //mock
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
