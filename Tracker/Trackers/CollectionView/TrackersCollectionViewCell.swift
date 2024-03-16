//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 23.01.2024.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    // MARK: - delegate
    weak var delegate : TrackersCollectionViewCellDelegate?
    //MARK: - Identifer
    static let trakerSettingCell = "cell"
    // MARK: - UI ELEMENTS
    lazy var emojiLabel : UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = .ypBackground
        emojiLabel.font = .systemFont(ofSize: 16)
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = 14
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        rectView.addSubview(emojiLabel)

        return emojiLabel
    }()
    
    private lazy var pinImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        let image = UIImage(named: "pin.square")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        rectView.addSubview(imageView)
        return imageView
    }()
    
    lazy var rectView : UIView = {
        let rectView = UIView()
        rectView.translatesAutoresizingMaskIntoConstraints = false
        rectView.backgroundColor = .ypColorSelection6
        rectView.clipsToBounds = true
        rectView.layer.cornerRadius = 16
        rectView.layer.borderWidth = 1
        rectView.layer.borderColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 0.3).cgColor
        contentView.addSubview(rectView)
        self.rectView = rectView
        return rectView
    }()
    
    private lazy var trackerCaptionLabel : UILabel = {
        let caption = UILabel()
        caption.clipsToBounds = true
        caption.textColor = .ypWhite
        caption.font = .systemFont(ofSize: 12, weight: .medium)
        caption.lineBreakMode = .byWordWrapping
        caption.numberOfLines = 2
        caption.textAlignment = .left
        caption.translatesAutoresizingMaskIntoConstraints = false
        rectView.addSubview(caption)
        return caption
    }()
    
    private lazy var trackerCompleteButton : UIButton = {
        let completeButton = UIButton.systemButton(with:
                                                    UIImage(named: "button_add_tracker")!,
                                                   target: self,
                                                   action: #selector(didTaptrackerCompleteButton))
        completeButton.backgroundColor = rectView.backgroundColor
        completeButton.tintColor = .ypWhite
        completeButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        completeButton.layer.masksToBounds = true
        completeButton.layer.cornerRadius = 17
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(completeButton)
        self.trackerCompleteButton = completeButton
        return completeButton
    }()
    
    private lazy var trackersDaysCountLabel : UILabel = {
        let daysCountLabel = UILabel()
        daysCountLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysCountLabel.textColor = .ypBlack
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(daysCountLabel)
        self.trackersDaysCountLabel = daysCountLabel
        return daysCountLabel
    }()
    // MARK: - private
    private var uuid: UUID? = nil
    private var isCompleted: Bool = false
    private var indexPath: IndexPath?
    private var completeDays: Int = 0
    private var isPinned: Bool = true
    
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutRectView()
        
        
        layoutTrackerCompleteButton() 
        layoutTrackersDaysCountLabel()
        layoutpinImageView()
        layoutEmojiView()
        layoutTrackerCaptionLabel()
    }
    
    // MARK: - public func
    public func getUiid() -> UUID? {
        return self.uuid
    }
    public func getDaysCount() -> Int? {
        return self.completeDays
    }
    public func getPinnedStatus() -> Bool {
        return self.isPinned
    }
    public func cellSetting(uuid: UUID,
                            caption: String,
                            color: UIColor,
                            emoji: String,
                            completeDays: Int,
                            isCompleted: Bool,
                            isPinned: Bool,
                            indexPath: IndexPath
    ) {
        pinImageView.isHidden = !isPinned
        self.isPinned = isPinned
        self.uuid = uuid
        self.completeDays = completeDays
        self.trackerCaptionLabel.text = caption
        self.rectView.backgroundColor = color
        self.emojiLabel.text = emoji
        
        let localizedDayString = String.localizedStringWithFormat(
            NSLocalizedString(
                "numberOfDays",
                comment: "Number of remaining days"),
            completeDays
        )
        
        self.trackersDaysCountLabel.text = localizedDayString
        //self.trackerCompleteButton.isEnabled = isCompleted ? false : true
        self.trackerCompleteButton.backgroundColor = rectView.backgroundColor
        let plusImage = UIImage(named: "button_add_tracker")
        let doneImage = UIImage(named: "DoneButton")
        let image = isCompleted ? doneImage : plusImage
        self.trackerCompleteButton.setImage(image, for: .normal)
        self.indexPath = indexPath
    }
    

    // MARK: - OBJC
    @objc private func didTaptrackerCompleteButton() {
        guard let id = self.uuid, let indexPath = self.indexPath else {
            return
        }
        delegate?.addCompleteDay(id: id, indexPath: indexPath)
    }
    
    // MARK: - LAYOUT
    
    private func layoutpinImageView() {
        NSLayoutConstraint.activate([
            pinImageView.trailingAnchor.constraint(equalTo: rectView.trailingAnchor, constant: -12),
            pinImageView.topAnchor.constraint(equalTo: rectView.topAnchor, constant: 18)
        ])
    }
    
    private func layoutRectView() {
        NSLayoutConstraint.activate([
            rectView.widthAnchor.constraint(equalToConstant: 167),
            rectView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func layoutEmojiView() {
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: rectView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: rectView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 28),
            emojiLabel.widthAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func layoutTrackerCaptionLabel() {
        NSLayoutConstraint.activate([
            trackerCaptionLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor,constant: 8),
            trackerCaptionLabel.leadingAnchor.constraint(equalTo: rectView.leadingAnchor, constant: 12),
            trackerCaptionLabel.trailingAnchor.constraint(equalTo: rectView.trailingAnchor, constant: -12),
            trackerCaptionLabel.bottomAnchor.constraint(equalTo: rectView.bottomAnchor,constant: -12)
        ])
    }
    
    private func layoutTrackerCompleteButton() {
        NSLayoutConstraint.activate([
            trackerCompleteButton.topAnchor.constraint(equalTo: rectView.bottomAnchor, constant: 8),
            trackerCompleteButton.trailingAnchor.constraint(equalTo: rectView.trailingAnchor, constant: -12),
            trackerCompleteButton.widthAnchor.constraint(equalToConstant: 34),
            trackerCompleteButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func layoutTrackersDaysCountLabel() {
        NSLayoutConstraint.activate([
            trackersDaysCountLabel.leadingAnchor.constraint(equalTo: rectView.leadingAnchor, constant: 12),
            trackersDaysCountLabel.topAnchor.constraint(equalTo: rectView.bottomAnchor, constant: 16)
        ])
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
    // MARK: - REQ INIT
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
