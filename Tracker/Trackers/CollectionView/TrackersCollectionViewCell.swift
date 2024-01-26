//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 23.01.2024.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    lazy var emojiLabel : UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = .ypBackground
        emojiLabel.font = .systemFont(ofSize: 16)
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = 14
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        self.emojiLabel = emojiLabel
        return emojiLabel
    }()
    
   private lazy var rectView : UIView = {
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
        contentView.addSubview(caption)
        self.trackerCaptionLabel = caption
        return caption
    }()
    
    private lazy var trackerCompleteButton : UIButton = {
        let completeButton = UIButton.systemButton(with:
                                                    UIImage(named: "button_add_tracker")!,
                                                   target: self,
                                                   action: nil)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        rectViewLayout()
        emojiViewLayout()
        trackerCaptionLabelLayout()
        trackerCompleteButtonLayout() 
        trackersDaysCountLabelLayout()
        trackerCaptionLabel.text = "Кошка заслонила камеру на созвоне лмао"
        trackersDaysCountLabel.text = "1 день"
    }
    
    private func rectViewLayout() {
        NSLayoutConstraint.activate([
            rectView.widthAnchor.constraint(equalToConstant: 167),
            rectView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func emojiViewLayout() {
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: rectView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: rectView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 28),
            emojiLabel.widthAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func trackerCaptionLabelLayout() {
        NSLayoutConstraint.activate([
            trackerCaptionLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor,constant: 8),
            trackerCaptionLabel.leadingAnchor.constraint(equalTo: rectView.leadingAnchor, constant: 12),
            trackerCaptionLabel.trailingAnchor.constraint(equalTo: rectView.trailingAnchor, constant: -12),
            trackerCaptionLabel.bottomAnchor.constraint(equalTo: rectView.bottomAnchor,constant: -12)
        ])
    }
    
    private func trackerCompleteButtonLayout() {
        NSLayoutConstraint.activate([
            trackerCompleteButton.topAnchor.constraint(equalTo: rectView.bottomAnchor, constant: 8),
            trackerCompleteButton.trailingAnchor.constraint(equalTo: rectView.trailingAnchor, constant: -12),
            trackerCompleteButton.widthAnchor.constraint(equalToConstant: 34),
            trackerCompleteButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func trackersDaysCountLabelLayout() {
        NSLayoutConstraint.activate([
            trackersDaysCountLabel.leadingAnchor.constraint(equalTo: rectView.leadingAnchor, constant: 12),
            trackersDaysCountLabel.topAnchor.constraint(equalTo: rectView.bottomAnchor, constant: 16)
        ])
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
