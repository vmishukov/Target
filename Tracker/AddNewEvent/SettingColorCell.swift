//
//  SelectColorCell.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 10.02.2024.
//

import UIKit

final class SettingColorCell: UICollectionViewCell {
    //MARK: - Identifier
    static let cellIdentifier = "colorCell"
    //MARK: - UI ELEMENTS
    private lazy var colorRect: UIView = {
        let colorRect = UIView()
        colorRect.layer.cornerRadius = 6
        colorRect.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorRect)
        self.colorRect = colorRect
        return colorRect
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        colorRectConstraits()
    }
    //MARK: -  PUBLIC FUNC
    public func settingColorCell(color: UIColor) {
        self.colorRect.backgroundColor = color
    }
    
    //MARK: -  CONSTRAITS
    private func colorRectConstraits() {
        NSLayoutConstraint.activate([
            colorRect.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorRect.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorRect.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorRect.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    //MARK: - REQ INIT
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
