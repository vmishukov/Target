//
//  CategoryCell.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 09.03.2024.
//

import Foundation
import UIKit

final class CategoryCell: UITableViewCell {
    //MARK: - Identifer
    static let cellIdentifer = "CategoryCell"
    //MARK: - UI
    private lazy var chevronImage: UIImageView = {
        return UIImageView(image: UIImage(named: "DoneButton"))
    
    }()
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        self.detailTextLabel?.textColor = .ypGray
        chevronImage.isHidden = true
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Methods
    private func setupConstraints() {
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.addSubview(chevronImage)
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    // MARK: - public Methods
    func isCellHidden(_ check: Bool) {
        chevronImage.isHidden = check
    }
}
