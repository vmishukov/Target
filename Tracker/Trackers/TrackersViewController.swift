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
    
    
    private lazy var filterButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchDown)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle(NSLocalizedString( "trackers.filter", comment: ""), for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        self.filterButton = button
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
    
    private lazy var trackerSearchBar : UISearchController = {
        let trackerSearchBar = UISearchController()
        
        trackerSearchBar.searchBar.placeholder = NSLocalizedString( "trackers.searchbar.placeholder", comment: "")
        trackerSearchBar.searchBar.delegate = self
        trackerSearchBar.searchBar.searchBarStyle = .minimal
        trackerSearchBar.searchResultsUpdater = self
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
    
    private lazy var trackerNothingFoundImage : UIImageView = {
        let ImageView = UIImageView()
        let picture = UIImage(named: "nothing_found_image")
        ImageView.image = picture
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.isHidden = true
        view.addSubview(ImageView)
        return ImageView
    }()
    
    private lazy var trackerNothingFoundLabel : UILabel = {
        let trackerErrLabel = UILabel()
        trackerErrLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerErrLabel.font = UIFont.systemFont(ofSize: 12)
        trackerErrLabel.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        
        trackerErrLabel.attributedText = NSMutableAttributedString(string:  NSLocalizedString( "trackers.nothing.found.title", comment: ""), attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        trackerErrLabel.isHidden = true
        view.addSubview(trackerErrLabel)
        return trackerErrLabel
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
    private let yandexMobileMetrica = Analysis.shared
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .ypWhite
        
        navBarItem()
        viewModel = TrackersViewModel(date: trackerDatePicker.date)
        bind()
        
        cancelKeyboardGestureSetup()
        collectionView.dataSource = self
        collectionView.delegate = self
      
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.trakerSettingCell)
        
        collectionView.register(TrackersCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false

       // layoutSearchBar()
        layoutErrImage()
        layoutErrLabel()
        layoutTrackerNothingFoundImage()
        layoutЕrackerNothingFoundLabel()
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        collectionView.backgroundColor = .ypWhite
        layoutFilterButton()
    
        
        self.collectionView.isHidden = viewModel.stubStatus
        self.filterButton.isHidden = viewModel.stubStatus
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        yandexMobileMetrica.reportEvent(event: "Open TrackersViewController", parameters: ["event": "open", "screen": "Main"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        yandexMobileMetrica.reportEvent(event: "Closed TrackersViewController", parameters: ["event": "close", "screen": "Main"])
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
     
        navigationItem.searchController = trackerSearchBar
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
            
            if viewModel.getFilterCondition() != .AllTrackers {
                self.trackerNothingFoundImage.isHidden = false
                self.trackerNothingFoundLabel.isHidden = false
                self.trackerErrImage.isHidden = true
                self.trackerErrLabel.isHidden = true
                self.filterButton.isHidden = false
            } else {
                self.filterButton.isHidden = viewModel.stubStatus
                self.trackerNothingFoundImage.isHidden = true
                self.trackerNothingFoundLabel.isHidden = true
                self.trackerErrImage.isHidden = false
                self.trackerErrLabel.isHidden = false
            }
        }
    }
    
    // MARK: - Constraits
    
    private func layoutFilterButton() {
        NSLayoutConstraint.activate([
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    /*
    private func layoutSearchBar() {
        NSLayoutConstraint.activate([
            trackerSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            trackerSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            trackerSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -9)
        ])
        trackerSearchBar.directionalLayoutMargins = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
    */
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
    
    private func layoutЕrackerNothingFoundLabel() {
        NSLayoutConstraint.activate([
            trackerNothingFoundLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackerNothingFoundLabel.topAnchor.constraint(equalTo: trackerErrImage.bottomAnchor, constant: 8)
        ])
    }

    private func layoutTrackerNothingFoundImage() {
        NSLayoutConstraint.activate([
            trackerNothingFoundImage.widthAnchor.constraint(equalToConstant: 80),
            trackerNothingFoundImage.heightAnchor.constraint(equalToConstant: 80),
            trackerNothingFoundImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackerNothingFoundImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    // MARK: - OBJC
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        viewModel.setFilterDate(filterDate: trackerDatePicker.date)
        
        if viewModel.getFilterCondition() == .TrackersForToday && trackerDatePicker.date != Calendar.current.startOfDay(for: Date()) {
            viewModel.setFilterCondition(filter: .AllTrackers)
        }
        
    }
    
    @objc private func didTapAddTrackerButton(_ sender: UIButton) {
        yandexMobileMetrica.reportEvent(event: "Add tracker button tapped on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "add_track"])
        let view = AddTrackersViewController()
        view.trackerViewdelegate = viewModel
        present(view, animated: true)
    }
    
    @objc private func hideKeyboard() {
        self.trackerSearchBar.searchBar.endEditing(true)
    }
    
    @objc private func didTapFilterButton(_ sender: UIButton) {
        yandexMobileMetrica.reportEvent(event: "Filter button tapped on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "filter"])
        let view = FilterTrackersViewController()
      //  print(viewModel.getFilterCondition()?.title)
        view.selectedFilter = viewModel.getFilterCondition()
        view.delegate = self
        present(view, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(indexPath: indexPath)
     }
    
    func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { (action) -> UIMenu? in
            guard let cell = self.collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else {
                return nil
            }
            var pinTitle: String = ""
            if cell.getPinnedStatus() {
                pinTitle =  NSLocalizedString( "trackers.context.unpin", comment: "")
            } else {
                pinTitle =  NSLocalizedString( "trackers.context.pin", comment: "")
            }
            let pin = UIAction(title: pinTitle ) { (_) in
                guard let uuid = cell.getUiid() else { return }
                self.viewModel.changePinStatus(trackerId: uuid)
            }
            
            let edit = UIAction(title: NSLocalizedString( "trackers.context.edit", comment: "") ) { (_) in
                let view = EditHabbitViewController()
                
                self.yandexMobileMetrica.reportEvent(event: "Did tap edit tracker on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "edit"])
                
                guard let uuid = cell.getUiid(), let completeDays = cell.getDaysCount() else { return }
                view.trackerId = uuid
                view.completeDays = completeDays
                self.present(view,animated: true)
            }

            let deleteAction = UIAction(title: NSLocalizedString("trackers.context.delete.alert.delete", comment: ""), attributes: .destructive) { _ in
                self.yandexMobileMetrica.reportEvent(event: "Did tap delete Tracker on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "delete"])
                let deleteAction = UIAlertAction(title: NSLocalizedString("trackers.context.delete.alert.delete", comment: ""), style: .destructive) { _ in
                    guard let uuid = cell.getUiid() else { return }
                    self.viewModel.removeTracker(trackerId: uuid)
                }
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("trackers.context.delete.alert.cancel", comment: ""), style: .cancel)
                
                let alert = UIAlertController(title: NSLocalizedString("trackers.context.delete.alert.title", comment: ""), message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }

            return UIMenu( children: [pin,edit, deleteAction])
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
        
        let previewView = cell.rectView
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
                         isPinned: tracker.isPinned,
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
        self.trackerSearchBar.searchBar.endEditing(true)
     }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.trackerSearchBar.searchBar.endEditing(true)
    }
}
// MARK: - TrackersCollectionViewCellDelegate
extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func addCompleteDay(id: UUID, indexPath: IndexPath) {
        yandexMobileMetrica.reportEvent(event: "Did tap complete tracker on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "track"])
        viewModel.addCompleteDay(id: id)
    }
}
//MARK: - FilterViewControllerDelegate
extension TrackersViewController: FilterViewControllerDelegate {
    func setFilter(filter: Filter) {
        if filter == .TrackersForToday {
            trackerDatePicker.date = Calendar.current.startOfDay(for: Date())
        }
        viewModel.setFilterCondition(filter: filter)
    }
}
//MARK: - UISearchResultsUpdating
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       // searchText = searchController.searchBar.text ?? ""
       // isHiddenFilterButton()
        viewModel.setFilterText(filterString: trackerSearchBar.searchBar.text)
    }
}
