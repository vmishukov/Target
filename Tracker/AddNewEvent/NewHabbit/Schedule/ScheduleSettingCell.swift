//
//  ScheduleSettingCell.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 26.01.2024.
//

import Foundation

import UIKit

final class ScheduleSettingCell: UITableViewCell {
    //MARK: - Identifer
    static let cellIdentifer = "cell"
    //MARK: - UI
    
    private lazy var daySwitch: UISwitch = {
       let daySwitch = UISwitch()
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        daySwitch.onTintColor = .ypBlue
        self.daySwitch = daySwitch
        contentView.addSubview(daySwitch)
        return daySwitch
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .ypBackground
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Methods
    private func setupConstraints() {
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        NSLayoutConstraint.activate([
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 75),
            daySwitch.heightAnchor.constraint(equalToConstant: 31),
            daySwitch.widthAnchor.constraint(equalToConstant: 51)
        ])
    }
}
