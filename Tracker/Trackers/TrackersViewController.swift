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
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        self.addTrackerButton = button
        return button
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
        trackerSearchBar.placeholder = NSLocalizedString( "trackers.searchbar.placeholder", comment: "")
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
       
        trackerErrLabel.attributedText = NSMutableAttributedString(string:  NSLocalizedString( "trackers.null.title", comment: ""), attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        view.addSubview(trackerErrLabel)
        return trackerErrLabel
    }()
    // MARK: - Private
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
    private var viewModel: TrackersViewModel!
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        navBarItem()
        viewModel = TrackersViewModel(date: trackerDatePicker.date)
        bind()
        
        cancelKeyboardGestureSetup()
        collectionView.dataSource = self
        collectionView.delegate = self
      
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.trakerSettingCell)
        
        collectionView.register(TrackersCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        self.collectionView.isHidden = viewModel.stubStatus
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
        navigationBar.topItem?.title = NSLocalizedString("trackers.title", comment: "")
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

    private func bind() {
        viewModel.visibleCategoriesBinding = { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
        
        viewModel.stubStatusBinding = { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.isHidden = viewModel.stubStatus
        }
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
        viewModel.setFilterDate(filterDate: trackerDatePicker.date)
    }
    
    @objc private func didTapAddTrackerButton(_ sender: UIButton) {
        let view = AddTrackersViewController()
        view.trackerViewdelegate = viewModel
        present(view, animated: true)
    }
    
    @objc private func hideKeyboard() {
        self.trackerSearchBar.endEditing(true)
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu()
     }
    
    func configureContextMenu() -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let pin = UIAction(title: NSLocalizedString( "trackers.tracker.pin", comment: "") ) { (_) in
                print("edit button clicked")
                
            }
            
            let edit = UIAction(title: NSLocalizedString( "trackers.tracker.edit", comment: "") ) { (_) in
                print("edit button clicked")
                
            }

            
            let delete = UIAction(title: NSLocalizedString( "trackers.tracker.delete", comment: ""),attributes: .destructive) { (_) in
                print("delete button clicked")
                //add tasks...
            }
            
            return UIMenu( children: [pin,edit,delete])
        }
        return context
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else {
            print(configuration.identifier)
            print(configuration.identifier as? IndexPath )
            return nil}
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else {
            return nil
        }
        
        let previewView = cell.emojiLabel
        let targetedPreview = UITargetedPreview(view: previewView)
        return targetedPreview
    }
    
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
        viewModel.visibleCategories.count
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
        return viewModel.visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackersCollectionViewCell else {return UICollectionViewCell()}
        
        let tracker = viewModel.visibleCategories[indexPath.section].trackers[indexPath.row]
        let completeDays = viewModel.completedTrackers.filter { $0.id == tracker.id }.count
        
        let isCompleted = viewModel.completedTrackers.contains { record in
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
        view.headerCategoryLabel.text = viewModel.visibleCategories[indexPath.section].title
        return view
    }
}

// MARK: - TrackersCollectionViewCellDelegate
extension TrackersViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        viewModel.setFilterText(filterString: searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
     self.trackerSearchBar.endEditing(true)
     }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.trackerSearchBar.endEditing(true)
    }
}
// MARK: - TrackersCollectionViewCellDelegate
extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func addCompleteDay(id: UUID, indexPath: IndexPath) {
        viewModel.addCompleteDay(id: id)
    }
}
