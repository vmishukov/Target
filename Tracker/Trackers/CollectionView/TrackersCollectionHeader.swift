//
//  TrackersCollectionHeader.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 24.01.2024.
//

import UIKit

class TrackersCollectionHeader: UICollectionReusableView {
    
    lazy var headerCategoryLabel : UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.font = .systemFont(ofSize: 19, weight: .bold)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoryLabel)
        return categoryLabel
    }()
    
    static let identifier = "header"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutHeaderCategoryLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func layoutHeaderCategoryLabel() {
        NSLayoutConstraint.activate([
            headerCategoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -12),
            headerCategoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerCategoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
}
