//
//  EditHabbitViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 12.03.2024.
//

import UIKit
import Foundation

final class EditHabbitViewController: UIViewController {
    // MARK: - public variable
    var trackerId: UUID?
    var completeDays: Int?
    // MARK: - private
    private var viewModel: EditHabbitViewModelProtocol?
    //MARK: - UI
    private let editHabbitCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var editHabbitTitle : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("edit.habbit.title", comment: "")
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.editHabbitTitle = titleLabel
        return titleLabel
    }()
    
    private lazy var editHabbitDaysCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        containerView.addSubview(label)
        return label
    }()
    
    private lazy var editHabbitScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
 
        self.editHabbitScrollView = scrollView
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
    
    private lazy var editHabbitTextField : UITextField = {
        let editHabbitTextField = UITextField()
        let paddingViewLeft: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        editHabbitTextField.leftView = paddingViewLeft
        editHabbitTextField.leftViewMode = .always
        if let title = viewModel?.selectedTitle {
            editHabbitTextField.text = title
        }
        editHabbitTextField.layer.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3).cgColor
        editHabbitTextField.translatesAutoresizingMaskIntoConstraints = false
        editHabbitTextField.placeholder = NSLocalizedString("event.placeholder", comment: "")
        editHabbitTextField.layer.cornerRadius = 16
        editHabbitTextField.clearButtonMode = .always
        editHabbitTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        editHabbitTextField.addSubview(editHabbitErrLabel)
        containerView.addSubview(editHabbitTextField)
        self.editHabbitTextField = editHabbitTextField
        self.editHabbitTextField.delegate = self
        return editHabbitTextField
    }()
    
    private lazy var editHabbitErrLabel : UILabel = {
        let errLabel = UILabel()
        errLabel.text = NSLocalizedString("placeholder.restrict.label", comment: "")
        errLabel.font = .systemFont(ofSize: 17)
        errLabel.textColor = .ypRed
        errLabel.translatesAutoresizingMaskIntoConstraints = false
        errLabel.textAlignment = .center
        errLabel.isHidden = true
        self.editHabbitErrLabel = errLabel
        return errLabel
    }()
    
    private lazy var editHabbitSettingsTableView: UITableView = {
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
        self.editHabbitSettingsTableView = settingsTableView
        containerView.addSubview(settingsTableView)
        return settingsTableView
    }()
    
    private lazy var editHabbittCancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(NSLocalizedString("cancel.button", comment: ""), for: .normal)
        cancelButton.backgroundColor = .ypWhite
        cancelButton.tintColor = .ypRed
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.editHabbittCancelButton = cancelButton
        view.addSubview(cancelButton)
        return cancelButton
    }()
    
    private lazy var editHabbitCreateButton: UIButton = {
        let createButton = UIButton(type: .system)
        createButton.setTitle(NSLocalizedString("save.button", comment: ""), for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.backgroundColor = .ypGray
        createButton.tintColor = .ypWhite
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        self.editHabbitCreateButton = createButton
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
    
        stackView.addArrangedSubview(editHabbittCancelButton)
        stackView.addArrangedSubview(editHabbitCreateButton)
        self.newHabbbitButtonStackView = stackView
        view.addSubview(stackView)
        return stackView
    }()
//MARK: - LIFECYCLE
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        
        
        let localizedDayString = String.localizedStringWithFormat(
            NSLocalizedString(
                "numberOfDays",
                comment: "Number of remaining days"),
            self.completeDays ?? 0
        )
        editHabbitDaysCountLabel.text = localizedDayString
        viewModel = EditHabbitViewModel(trackerId: trackerId!)
        
        constraiteditHabbitTitle()
        constraitEditHabbitDaysCountLabel()
        constraiteditHabbitScrollView()
        constraitContainerView()
        constraiteditHabbitTextField()
        emojiCollectionSetup()
        
        constraiteditHabbitSettingsTableView()
        constraiteditHabbittButtons()
        updateButtonStatus()
        cancelKeyboardGestureSetup()
        super.viewDidLoad()
    }
    // MARK: - constrait
    private func constraitEmojiCollection() {
        NSLayoutConstraint.activate([
            editHabbitCollectionView.topAnchor.constraint(equalTo: editHabbitSettingsTableView.bottomAnchor),
            editHabbitCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            editHabbitCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            editHabbitCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -16),
        ])
    }
    private func constraitContainerView() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: editHabbitScrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: editHabbitScrollView.leadingAnchor),
            containerView.widthAnchor.constraint(equalTo: editHabbitScrollView.widthAnchor),
            containerView.trailingAnchor.constraint(equalTo: editHabbitScrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: editHabbitScrollView.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: editHabbitScrollView.heightAnchor,constant: 250)
        ])
    }
    private func constraiteditHabbitScrollView() {
        NSLayoutConstraint.activate([
            editHabbitScrollView.topAnchor.constraint(equalTo: editHabbitTitle.bottomAnchor, constant: 38),
            editHabbitScrollView.bottomAnchor.constraint(equalTo: newHabbbitButtonStackView.topAnchor,constant: -16),
            editHabbitScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editHabbitScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    private func constraiteditHabbitTitle() {
        NSLayoutConstraint.activate([
            editHabbitTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editHabbitTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func constraiteditHabbitTextField() {
        NSLayoutConstraint.activate([
            editHabbitTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            editHabbitTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            editHabbitTextField.topAnchor.constraint(equalTo: editHabbitDaysCountLabel.bottomAnchor,constant: 40),
            editHabbitTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        constraiteditHabbitErrLabel()
    }
    
    
    private func constraitEditHabbitDaysCountLabel() {
        NSLayoutConstraint.activate([
            editHabbitDaysCountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            editHabbitDaysCountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
    
            editHabbitDaysCountLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
       
        ])
    }
    
    private func constraiteditHabbitErrLabel() {
        NSLayoutConstraint.activate([
            editHabbitErrLabel.centerXAnchor.constraint(equalTo: editHabbitTextField.centerXAnchor),
            editHabbitErrLabel.topAnchor.constraint(equalTo: editHabbitTextField.bottomAnchor, constant: 8)
        ])
    }
    
    private func constraiteditHabbitSettingsTableView() {
        NSLayoutConstraint.activate([
            editHabbitSettingsTableView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            editHabbitSettingsTableView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            editHabbitSettingsTableView.topAnchor.constraint(equalTo: editHabbitTextField.bottomAnchor, constant: 24),
            editHabbitSettingsTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func constraiteditHabbittButtons() {
        NSLayoutConstraint.activate([
            newHabbbitButtonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            newHabbbitButtonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            newHabbbitButtonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            editHabbitCreateButton.heightAnchor.constraint(equalToConstant: 60),
            editHabbittCancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    //MARK: - PRIVATE
    private func updateButtonStatus() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        if editHabbitTextField.text?.count ?? 0 > 0 && viewModel?.schedule?.count ?? 0 > 0 && viewModel?.selectedColor != nil && viewModel?.selectedEmoji != nil && viewModel?.categoryName != nil {
            editHabbitCreateButton.isEnabled = true
            editHabbitCreateButton.backgroundColor = .ypBlack
        } else {
            editHabbitCreateButton.isEnabled = false
            editHabbitCreateButton.backgroundColor = .ypGray
        }
         
    }
    private func cancelKeyboardGestureSetup() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    private func emojiCollectionSetup() {
        editHabbitCollectionView.delegate = self
        editHabbitCollectionView.dataSource = self
        editHabbitCollectionView.isScrollEnabled = false
        editHabbitCollectionView.bounces = false
        editHabbitCollectionView.allowsMultipleSelection = true
        editHabbitCollectionView.register(SettingEmojiCell.self, forCellWithReuseIdentifier: SettingEmojiCell.cellIdentifier)
        editHabbitCollectionView.register(SettingColorCell.self, forCellWithReuseIdentifier: SettingColorCell.cellIdentifier)
        editHabbitCollectionView.register(SettingCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingCollectionHeader.identifier)
        editHabbitCollectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(editHabbitCollectionView)
        constraitEmojiCollection()
    }
 //MARK: - OBJC
    @objc func cancelButtonClicked() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    @objc func hideKeyboard() {
        self.editHabbitTextField.endEditing(true)
    }
    
    @objc func createButtonClicked() {
        viewModel?.edtiTracker()
        self.dismiss(animated: true)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateButtonStatus()
        viewModel?.selectedTitle = textField.text
    }
}
// MARK: - UICollectionViewDelegate
extension EditHabbitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: true) })
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let emoji = viewModel?.emojiArray[indexPath.row]
            viewModel?.selectedEmoji = emoji
        } else {
            let color = viewModel?.sectionColors[indexPath.row]
            viewModel?.selectedColor = color
        }
        updateButtonStatus()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel?.selectedEmoji = nil
        } else {
            viewModel?.selectedColor = nil
        }
        updateButtonStatus()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EditHabbitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availibleWidth = editHabbitCollectionView.frame.width - 9
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
extension EditHabbitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItemsInSection = section == 0 ? viewModel?.emojiArray.count ?? 0 : viewModel?.sectionColors.count ?? 0
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingEmojiCell.cellIdentifier, for: indexPath) as? SettingEmojiCell else {return UICollectionViewCell()}
            
            if let emoji = viewModel?.emojiArray[indexPath.row] {
                if emoji == viewModel?.selectedEmoji {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                }
                cell.settingEmojiCell(emoji: emoji)
                return cell
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingColorCell.cellIdentifier, for: indexPath) as? SettingColorCell else {return UICollectionViewCell()}
            if let color = viewModel?.sectionColors[indexPath.row] {
                if color == viewModel?.selectedColor {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                }
                cell.settingColorCell(color: color)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingCollectionHeader.identifier, for: indexPath) as! SettingCollectionHeader
        indexPath.section == 0 ? view.settingHeaderSetup(titleText: NSLocalizedString("emoji.customization.label", comment: "")) :  view.settingHeaderSetup(titleText: NSLocalizedString("color.customization.label", comment: ""))
        return view
    }
}
// MARK: - UITableViewDataSource
extension EditHabbitViewController: UITableViewDataSource {
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
            cell.textLabel?.text = NSLocalizedString("category.customization", comment: "")
            if let categoryName = viewModel?.categoryName {
                cell.detailTextLabel?.text = categoryName
            }
        case 1 :
            cell.textLabel?.text = NSLocalizedString("schedule.customization", comment: "")
            var text: String = ""
            if let schedule = viewModel?.schedule {
                for (idx, element) in schedule.enumerated() {
                    if idx == schedule.endIndex-1 {
                        text += element.shortDayName
                    } else {
                        text += element.shortDayName + ", "
                    }
                }
            }
            cell.detailTextLabel?.text = text
        default:
            ""
        }
        cell.backgroundColor = .ypBackground
        return cell
    }
}
// MARK: - UITableViewDelegate
extension EditHabbitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            
            let view = CategoryViewController()
            view.delegate = self
            let cell = editHabbitSettingsTableView.cellForRow(at: indexPath)
            view.selectedCategory = cell?.detailTextLabel?.text
            present(view,animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        case 1 :
            let view = ScheduleViewController()
            view.delegate = self
            view.selectedDays = self.viewModel?.schedule
            present(view,animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
// MARK: - UITextFieldDelegate
extension EditHabbitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count ?? 0) +  (string.count - range.length) >= 38 {
            editHabbitErrLabel.isHidden = false
            return false
        }
        editHabbitErrLabel.isHidden = true
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        editHabbitErrLabel.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.editHabbitTextField.resignFirstResponder()
        return true
    }
}
// MARK: - ScheduleViewControllerDelegate
extension EditHabbitViewController: ScheduleViewControllerDelegate {
    func getSelectedDays(schedule: [Weekday]) {
        self.viewModel?.schedule = schedule
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = editHabbitSettingsTableView.cellForRow(at: indexPath)
        
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
        editHabbitSettingsTableView.reloadData()
    }
}
// MARK: - CategoryViewControllerDelegate
extension EditHabbitViewController: CategoryViewControllerDelegate {
    func setSelectedCategory(categoryName: String?) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = editHabbitSettingsTableView.cellForRow(at: indexPath)
        viewModel?.categoryName = categoryName
        cell?.detailTextLabel?.text = categoryName
        updateButtonStatus()
    }
}
