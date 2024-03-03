//
//  SettingCollectionHeader.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 11.02.2024.
//

import UIKit

final class SettingCollectionHeader: UICollectionReusableView {
    //MARK: - IDENTIFIER
    static let identifier = "settingHeader"
    
    //MARK: - UI ELEMENTS
    private lazy var headerTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        return titleLabel
    }()
    //MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerTitleLabelConstraits()
    }
    //MARK: - PUBLIC
    public func settingHeaderSetup(titleText: String) {
        headerTitleLabel.text = titleText
    }
    //MARK: - CONSTRAITS
    private func headerTitleLabelConstraits() {
        NSLayoutConstraint.activate([
            headerTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -24),
            headerTitleLabel.topAnchor.constraint(equalTo: topAnchor,constant: 24),
            headerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7)

        ])
    }
    //MARK: - REQ INIT
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
