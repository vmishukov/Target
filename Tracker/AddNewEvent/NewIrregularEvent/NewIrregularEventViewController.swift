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
    // MARK: - DELEGATE
    weak var addTrackerDelegate: AddTrackersViewControllerDelegate?
    // MARK: - PRIVATE
    private let emojiArray = Constants.emojiArray
    private let sectionColors = Constants.sectionColors
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    // MARK: - UI ELEMENTS
    private let NewIrregularEventCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var NewIrregularEventScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
 
        self.NewIrregularEventScrollView = scrollView
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
    
    private lazy var NewIrregularEventTitle : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("irr.event.title", comment: "")
      
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
        newIrregularEventTextField.placeholder = NSLocalizedString("irr.event.placeholder", comment: "")
        newIrregularEventTextField.layer.cornerRadius = 16
        
        newIrregularEventTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        
        newIrregularEventTextField.clearButtonMode = .always
        newIrregularEventTextField.addSubview(newIrregularEventLabel)
        containerView.addSubview(newIrregularEventTextField)
        self.newIrregularEventTextField = newIrregularEventTextField
        self.newIrregularEventTextField.delegate = self
        return newIrregularEventTextField
    }()
    
    private lazy var newIrregularEventLabel : UILabel = {
        let errLabel = UILabel()
        errLabel.text = NSLocalizedString("placeholder.restrict.label", comment: "")
        errLabel.font = .systemFont(ofSize: 17)
        errLabel.textColor = .ypRed
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
        containerView.addSubview(settingsTableView)
        return settingsTableView
    }()
    
    private lazy var newIrregularEventCancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(NSLocalizedString("cancel.button", comment: ""), for: .normal)
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
        createButton.setTitle(NSLocalizedString("create.button", comment: ""), for: .normal)
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
    // MARK: - lifecycle
    override func viewDidLoad() {
        view.backgroundColor = .ypWhite
        layoutNewIrregularEventTextField()
        layoutNewIrregularEventTitle()
        cancelKeyboardGestureSetup()
        constraitNewIrregularEventScrollView()
        constraitContainerView()
        emojiCollectionSetup()
        
        layoutNewIrregularEventSettingsTableView()
        
        layoutNewIrregularEventtButtons()
        constraitContainerView()
        updateButtonStatus()
        super.viewDidLoad()
    }
    // MARK: - CONSTRAITS
    private func layoutNewIrregularEventTitle() {
        NSLayoutConstraint.activate([
            NewIrregularEventTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NewIrregularEventTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func layoutNewIrregularEventTextField() {
        NSLayoutConstraint.activate([
            newIrregularEventTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            newIrregularEventTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            newIrregularEventTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            newIrregularEventTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        layoutNewIrregularEventErrLabel()
    }
    
    private func layoutNewIrregularEventErrLabel() {
        NSLayoutConstraint.activate([
            newIrregularEventLabel.centerXAnchor.constraint(equalTo: newIrregularEventTextField.centerXAnchor),
            newIrregularEventLabel.topAnchor.constraint(equalTo: newIrregularEventTextField.bottomAnchor, constant: 8)
        ])
    }
    
    private func layoutNewIrregularEventSettingsTableView() {
        NSLayoutConstraint.activate([
            newIrregularEventSettingsTableView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newIrregularEventSettingsTableView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            newIrregularEventSettingsTableView.topAnchor.constraint(equalTo: newIrregularEventTextField.bottomAnchor, constant: 24),
            newIrregularEventSettingsTableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func layoutNewIrregularEventtButtons() {
        NSLayoutConstraint.activate([
            newHabbbitButtonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            newHabbbitButtonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            newHabbbitButtonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            newIrregularEventCreateButton.heightAnchor.constraint(equalToConstant: 60),
            newIrregularEventCancelButton.heightAnchor.constraint(equalToConstant: 60)

        ])
    }
    
    private func constraitEmojiCollection() {
        NSLayoutConstraint.activate([
            NewIrregularEventCollectionView.topAnchor.constraint(equalTo: newIrregularEventSettingsTableView.bottomAnchor),
            NewIrregularEventCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            NewIrregularEventCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            NewIrregularEventCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -16),
        ])
    }
    
    private func constraitContainerView() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: NewIrregularEventScrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: NewIrregularEventScrollView.leadingAnchor),
            containerView.widthAnchor.constraint(equalTo: NewIrregularEventScrollView.widthAnchor),
            containerView.trailingAnchor.constraint(equalTo: NewIrregularEventScrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: NewIrregularEventScrollView.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: NewIrregularEventScrollView.heightAnchor,constant: 90)
        ])
    }
    
    private func constraitNewIrregularEventScrollView() {
        NSLayoutConstraint.activate([
            NewIrregularEventScrollView.topAnchor.constraint(equalTo: NewIrregularEventTitle.bottomAnchor, constant: 38),
            NewIrregularEventScrollView.bottomAnchor.constraint(equalTo: newHabbbitButtonStackView.topAnchor,constant: -16),
            NewIrregularEventScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            NewIrregularEventScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - OBJC
    @objc func cancelButtonClicked() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc func hideKeyboard() {
        self.newIrregularEventTextField.endEditing(true)
    }
    
    @objc func createButtonClicked() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = newIrregularEventSettingsTableView.cellForRow(at: indexPath)
        guard let categoryTitle = cell?.detailTextLabel?.text , let caption = newIrregularEventTextField.text, let selectedColor = self.selectedColor, let selectedEmoji = self.selectedEmoji  else { return }

        let schedule = [Weekday.Monday, Weekday.Tuesday, Weekday.Wednesday, Weekday.Thursday, Weekday.Friday, Weekday.Saturday, Weekday.Sunday]
        
        let tracker = Tracker(id: UUID(), title: caption, color: selectedColor, emoji: selectedEmoji, isHabbit: false, isPinned: false, schedule: schedule)
        
        self.addTrackerDelegate?.addNewTracker(tracker: tracker, categoryTitle: categoryTitle)
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateButtonStatus()
    }
    // MARK: - private func
    private func updateButtonStatus() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = newIrregularEventSettingsTableView.cellForRow(at: indexPath)
        
        if newIrregularEventTextField.text?.count ?? 0 > 0 && selectedColor != nil && selectedEmoji != nil && cell?.detailTextLabel?.text != nil {
            newIrregularEventCreateButton.isEnabled = true
            newIrregularEventCreateButton.backgroundColor = .ypBlack
        } else {
            newIrregularEventCreateButton.isEnabled = false
            newIrregularEventCreateButton.backgroundColor = .ypGray
        }
    }
    private func cancelKeyboardGestureSetup() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func emojiCollectionSetup() {
        NewIrregularEventCollectionView.delegate = self
        NewIrregularEventCollectionView.dataSource = self
        NewIrregularEventCollectionView.isScrollEnabled = false
        NewIrregularEventCollectionView.bounces = false
        NewIrregularEventCollectionView.allowsMultipleSelection = true
        NewIrregularEventCollectionView.register(SettingEmojiCell.self, forCellWithReuseIdentifier: SettingEmojiCell.cellIdentifier)
        NewIrregularEventCollectionView.register(SettingColorCell.self, forCellWithReuseIdentifier: SettingColorCell.cellIdentifier)
        NewIrregularEventCollectionView.register(SettingCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingCollectionHeader.identifier)
        NewIrregularEventCollectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(NewIrregularEventCollectionView)
        constraitEmojiCollection()
    }
}
// MARK: - UICollectionViewDelegate
extension NewIrregularEventViewController: UICollectionViewDelegate {
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
extension NewIrregularEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availibleWidth = NewIrregularEventCollectionView.frame.width - 9
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
extension NewIrregularEventViewController: UICollectionViewDataSource {
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
        indexPath.section == 0 ? view.settingHeaderSetup(titleText: NSLocalizedString("emoji.customization.label", comment: "")) :  view.settingHeaderSetup(titleText: NSLocalizedString("color.customization.label", comment: ""))
        return view
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
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.newIrregularEventTextField.resignFirstResponder()
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
            cell.textLabel?.text = NSLocalizedString("category.customization", comment: "")
        default:
            ""
        }
        cell.backgroundColor = .ypBackground
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NewIrregularEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            let view = CategoryViewController()
            view.delegate = self
            let cell = newIrregularEventSettingsTableView.cellForRow(at: indexPath)
            view.selectedCategory = cell?.detailTextLabel?.text
            present(view,animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
    
// MARK: - CategoryViewControllerDelegate
extension NewIrregularEventViewController: CategoryViewControllerDelegate {
    func setSelectedCategory(categoryName: String?) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = newIrregularEventSettingsTableView.cellForRow(at: indexPath)
        cell?.detailTextLabel?.text = categoryName
        updateButtonStatus()
    }
}
