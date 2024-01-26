//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 15.01.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
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
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let emojis = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄"]
    
    private var categories: [TrackerCategory]?
    private var completeTrackers: [TrackerRecord]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TrackersCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        navBarItem()
    
        searchBarLayout()
        errImageLayout()
        errLabelLayout()
        
        view.addSubview(collectionView)
       
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: trackerSearchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    @objc private func didTapAddTrackerButton(_ sender: UIButton) {
        let view = AddTrackersViewController()
     
        present(view, animated: true)
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
    
    private func searchBarLayout() {
        NSLayoutConstraint.activate([
            trackerSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            trackerSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            trackerSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -9)
        ])
        trackerSearchBar.directionalLayoutMargins = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
    
    private func errImageLayout() {
        NSLayoutConstraint.activate([
            trackerErrImage.widthAnchor.constraint(equalToConstant: 80),
            trackerErrImage.heightAnchor.constraint(equalToConstant: 80),
            trackerErrImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackerErrImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        
        ])
    }
    
    private func errLabelLayout() {
        NSLayoutConstraint.activate([
            trackerErrLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackerErrLabel.topAnchor.constraint(equalTo: trackerErrImage.bottomAnchor, constant: 8)
        ])
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
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize  {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: 50, height: 50), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}


// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackersCollectionViewCell
        cell?.emojiLabel.text = emojis[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackersCollectionHeader
        
        return view
    }
}