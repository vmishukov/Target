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
    //MARK: - IS SELECTED
    override var isSelected: Bool {
        didSet {
            self.layer.backgroundColor = isSelected ? colorRect.backgroundColor?.withAlphaComponent(0.4).cgColor : UIColor.ypWhite.cgColor
        }
    }
    //MARK: - UI ELEMENTS
    private lazy var colorRect: UIView = {
        let colorRect = UIView()
        colorRect.layer.cornerRadius = 6
        colorRect.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorRect)
        self.colorRect = colorRect
        return colorRect
    }()
    
    private lazy var whiteRect: UIView = {
        let whiteRect = UIView()
        whiteRect.layer.cornerRadius = 4
        whiteRect.translatesAutoresizingMaskIntoConstraints = false
        whiteRect.layer.backgroundColor = UIColor.ypWhite.cgColor
        contentView.addSubview(whiteRect)
        return whiteRect
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 7
        whiteRectConstraits()
        colorRectConstraits()
    }
    //MARK: -  PUBLIC FUNC
    public func settingColorCell(color: UIColor) {
        self.colorRect.backgroundColor = color
    }
    
    //MARK: -  CONSTRAITS
    private func colorRectConstraits() {
        NSLayoutConstraint.activate([
            colorRect.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorRect.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            colorRect.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 6),
            colorRect.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -6)
        ])
    }
    private func whiteRectConstraits() {
        NSLayoutConstraint.activate([
            whiteRect.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            whiteRect.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            whiteRect.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 3),
            whiteRect.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -3)
        ])
    }
    
    //MARK: - REQ INIT
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
