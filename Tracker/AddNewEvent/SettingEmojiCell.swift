//
//  SelectEmojiCell.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 10.02.2024.
//
import UIKit

final class SettingEmojiCell: UICollectionViewCell {
    //MARK: - Identifier
    static let cellIdentifier = "emojiCell"
    //MARK: - UI
    private lazy var emojiLabel : UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.textAlignment = .center
        emojiLabel.font = .systemFont(ofSize: 44)
        emojiLabel.layer.masksToBounds = true
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        self.emojiLabel = emojiLabel
        return emojiLabel
    }()
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        emojiLabelConstraints()
    }
    // MARK: - SETTING CELL
    public func settingEmojiCell(emoji: String) {
        self.emojiLabel.text = emoji
    }
    
    // MARK: - Constraints
    private func emojiLabelConstraints() {
    }
    // MARK: - REQ INIT
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


