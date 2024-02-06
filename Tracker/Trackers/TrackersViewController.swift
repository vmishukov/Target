//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 15.01.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - UI ELEMENTS
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
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
        picker.clipsToBounds = true
        picker.tintColor = .ypBlue
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        picker.heightAnchor.constraint(equalToConstant: 34).isActive = true
        picker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var trackerSearchBar : UISearchBar = {
        let trackerSearchBar = UISearchBar()
        trackerSearchBar.placeholder = "Поиск"
        trackerSearchBar.translatesAutoresizingMaskIntoConstraints = false
        trackerSearchBar.searchBarStyle = .minimal
        trackerSearchBar.delegate = self
        
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
    // MARK: - Private
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var categories: [TrackerCategory] = TrackersMock.trackersMock //MOCK FOR NOW
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private let dateFormatter = DateFormatter()
    
    
    // MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        reloadCurrentTrackers()
        cancelKeyboardGestureSetup()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.trakerSettingCell)
        
        collectionView.register(TrackersCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        navBarItem()
        layoutSearchBar()
        layoutErrImage()
        layoutErrLabel()
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: trackerSearchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    // MARK: - private func
    private func cancelKeyboardGestureSetup() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func navBarItem() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "Трекеры"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
        
        let leftButton = UIBarButtonItem(
            image: UIImage(named: "button_add_tracker"),
            style: .plain,
            target: self,
            action: #selector(Self.didTapAddTrackerButton))
        
        leftButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(customView: trackerDatePicker)
        navigationItem.rightBarButtonItem = rightButton
    }
    private func reloadCurrentTrackers() {
        let calendar = Calendar.current
        let filterDay = calendar.component(.weekday, from: trackerDatePicker.date)
        let filterText = (trackerSearchBar.text ?? "").lowercased()
        
        visibleCategories = categories.compactMap{ category in
            let trackers = category.trackers.filter {tracker in
                
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay.calendarDayNumber == filterDay
                } == true
                var irregularEventCondition = true
                
                if tracker.isHabbit == false 
                {
                    if self.completedTrackers.contains(where: { completeTracker in
                        completeTracker.id == tracker.id}) {
                        let inx = self.completedTrackers.firstIndex{ findTracker in findTracker.id == tracker.id
                        }
                        if self.completedTrackers[inx!].date.onlyDate ==  trackerDatePicker.date.onlyDate {
                            irregularEventCondition = true
                        } else {
                            irregularEventCondition = false
                        }
                    } else {
                        irregularEventCondition = true
                    }
                }
        
                let textCondition = tracker.title.lowercased().contains(filterText) || filterText.isEmpty
                
                return dateCondition && textCondition && irregularEventCondition
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
    
        stubSetting()
        collectionView.reloadData()
    }
    
    private func stubSetting() {
        if visibleCategories.count == 0 {
            collectionView.isHidden = true
               }
        else {
            collectionView.isHidden = false
        }
        print(visibleCategories.count)
    }
    
    // MARK: - Constraits
    private func layoutSearchBar() {
        NSLayoutConstraint.activate([
            trackerSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            trackerSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            trackerSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -9)
        ])
        trackerSearchBar.directionalLayoutMargins = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
    
    private func layoutErrImage() {
        NSLayoutConstraint.activate([
            trackerErrImage.widthAnchor.constraint(equalToConstant: 80),
            trackerErrImage.heightAnchor.constraint(equalToConstant: 80),
            trackerErrImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackerErrImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func layoutErrLabel() {
        NSLayoutConstraint.activate([
            trackerErrLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackerErrLabel.topAnchor.constraint(equalTo: trackerErrImage.bottomAnchor, constant: 8)
        ])
    }

    // MARK: - OBJC
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
        reloadCurrentTrackers()
    }
    
    @objc private func didTapAddTrackerButton(_ sender: UIButton) {
        let view = AddTrackersViewController()
        view.category = self.categories
        view.trackerViewdelegate = self
        present(view, animated: true)
    }
    
    @objc private func hideKeyboard() {
        self.trackerSearchBar.endEditing(true)
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
}
// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 9
        let cellWidth =  availableWidth / CGFloat(2)
        return CGSize(width: cellWidth,
                      height: 148)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
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
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackersCollectionViewCell else {return UICollectionViewCell()}
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let completeDays = completedTrackers.filter { $0.id == tracker.id }.count
        
        guard dateFormatter.date(from: dateFormatter.string(from: trackerDatePicker.date)) != nil else {return UICollectionViewCell()}
        let isCompleted = completedTrackers.contains { record in
            record.id == tracker.id && record.date.onlyDate == trackerDatePicker.date.onlyDate }
   
        cell.cellSetting(uuid: tracker.id,
                          caption: tracker.title,
                          color: tracker.color,
                          emoji: tracker.emoji,
                          completeDays: completeDays,
                          isCompleted: isCompleted,
                          indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackersCollectionHeader.identifier, for: indexPath) as! TrackersCollectionHeader
        view.headerCategoryLabel.font = .boldSystemFont(ofSize: 19)
        view.headerCategoryLabel.text = visibleCategories[indexPath.section].title
        return view
    }
}
// MARK: - TrackersCollectionViewCellDelegate
extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func addCompleteDay(id: UUID, indexPath: IndexPath) {
        
        let trackerCompleteDAY = TrackerRecord(Id: id, date: trackerDatePicker.date)
        
        if completedTrackers.contains(where: {record in record.id == trackerCompleteDAY.id && record.date.onlyDate == trackerCompleteDAY.date.onlyDate
        }) {
            if let index = completedTrackers.firstIndex(where: {record in record.id == trackerCompleteDAY.id && record.date.onlyDate == trackerCompleteDAY.date.onlyDate
            }) {
                completedTrackers.remove(at: index)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        else if(Date().onlyDate >= trackerDatePicker.date.onlyDate) {
            self.completedTrackers.append(trackerCompleteDAY)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: - TrackersCollectionViewCellDelegate
extension TrackersViewController: AddTrackersViewControllerDelegate {
    func addNewTracker(trackerCategory: [TrackerCategory]) {
        //чистка удаленных категорий
        self.categories = trackerCategory
        reloadCurrentTrackers()
    }
    
}

// MARK: - TrackersCollectionViewCellDelegate
extension TrackersViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        reloadCurrentTrackers()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
     self.trackerSearchBar.endEditing(true)
     }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.trackerSearchBar.endEditing(true)
    }
    
}
