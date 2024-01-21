//
//  NewHabbitViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 21.01.2024.
//

import Foundation
import UIKit

final class NewHabbitViewController: UIViewController {
    
    private lazy var NewHabbitTitle : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Новая привычка"
        titleLabel.textColor = UIColor(hex: "1A1B22")
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.NewHabbitTitle = titleLabel
        return titleLabel
    }()
    
    private lazy var NewHabbitTextField : UITextField = {
        let NewHabbitTextField = UITextField()
        
        view.addSubview(NewHabbitTextField)
        NewHabbitTextField.translatesAutoresizingMaskIntoConstraints = false
        self.NewHabbitTextField = NewHabbitTextField
        return NewHabbitTextField
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        newHabbitTextField()
        newHabbitTitleLayout()
        super.viewDidLoad()
    }
    
    private func newHabbitTitleLayout() {
        NSLayoutConstraint.activate([
            NewHabbitTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NewHabbitTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 13)
        ])
    }
    
    private func newHabbitTextField() {
        
    }
    
}
