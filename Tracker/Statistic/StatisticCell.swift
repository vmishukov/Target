//
//  StatisticCell.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 16.03.2024.
//

import Foundation
import UIKit

final class StatisticCell: UITableViewCell {
    //MARK: - IDENTIFIER
    static let identifier = "StatisticCell"
    
    //MARK: - UI
    private lazy var viewGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = .ypWhite
        viewGradient.addSubview(view)
        return view
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }()
    
    private lazy var statisticTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("statistic.complete.tracker.count", comment: "")
        view.addSubview(label)
        
        return label
    }()
    //MARK: - private
    private func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = viewGradient.bounds
        gradientLayer.colors = [
            UIColor.ypColorSelection1.cgColor,
            UIColor.ypColorSelection9.cgColor,
            UIColor.ypColorSelection3.cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        viewGradient.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //MARK: - layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .ypWhite
        
        constraitsViewGradient()
        constraitsView()
        constraitsCountLabel()
        constraitsStatisticTitle()
        setGradient()
    }
    
    //MARK: - public methods
    func setCount(_ count: Int) {
        countLabel.text = "\(count)"
    }
    
    //MARK: - Constraits
    private func constraitsViewGradient() {
        NSLayoutConstraint.activate([
            viewGradient.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewGradient.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewGradient.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewGradient.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    private func constraitsView() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: viewGradient.topAnchor, constant: 0.5),
            view.bottomAnchor.constraint(equalTo: viewGradient.bottomAnchor, constant: -0.5),
            view.leadingAnchor.constraint(equalTo: viewGradient.leadingAnchor, constant: 0.5),
            view.trailingAnchor.constraint(equalTo: viewGradient.trailingAnchor, constant: -0.5),
            ])
    }
    private func constraitsCountLabel() {
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: viewGradient.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: viewGradient.topAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: viewGradient.trailingAnchor, constant: -12),
        ])
    }
    
    private func constraitsStatisticTitle() {
        NSLayoutConstraint.activate([
        statisticTitle.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 7),
        statisticTitle.leadingAnchor.constraint(equalTo: viewGradient.leadingAnchor, constant: 12),
        statisticTitle.trailingAnchor.constraint(equalTo: viewGradient.trailingAnchor, constant: -12),
        ])
    }
}
