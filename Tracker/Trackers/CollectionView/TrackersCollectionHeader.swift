//
//  TrackersCollectionHeader.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 24.01.2024.
//

import UIKit

class TrackersCollectionHeader: UICollectionReusableView {
    
    private lazy var headerCategoryLabel : UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.font = .systemFont(ofSize: 19, weight: .bold)
        categoryLabel.text = "Домашний уют"
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoryLabel)
        
        return categoryLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerCategoryLabelLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func headerCategoryLabelLayout() {
        NSLayoutConstraint.activate([
            headerCategoryLabel.topAnchor.constraint(equalTo: topAnchor),
            headerCategoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
}
