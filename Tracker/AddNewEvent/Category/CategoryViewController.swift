//
//  CategoryView.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 09.03.2024.
//

import Foundation
import UIKit

final class CategoryViewController: UIViewController{
    //MARK: - UI ELEMENTS
    private lazy var categoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryErrImage : UIImageView = {
        let imageView = UIImageView()
        let picture = UIImage(named: "err")
        imageView.image = picture
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var categoryErrLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
 
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        paragraphStyle.alignment = .center
        label.numberOfLines = 2
        label.attributedText = NSMutableAttributedString(string: "Привычки и события можно \n объединить по смыслу", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        view.addSubview(label)
        return label
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.backgroundColor = .ypBlack
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypWhite
        constraitsCategoryLabel()
        constraitsCategoryErrImage()
        constraitsCategoryErrLabel()
        constraitsCategoryButton()
    }

    //MARK: - OBJC
    @objc private func didTapCategoryButton(_ sender: UIButton) {
        let view = NewCategoryViewController()
        present(view,animated: true)
        
    }
    //MARK: - Constraits
    private func constraitsCategoryLabel() {
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func constraitsCategoryErrImage() {
        NSLayoutConstraint.activate([
            categoryErrImage.widthAnchor.constraint(equalToConstant: 80),
            categoryErrImage.heightAnchor.constraint(equalToConstant: 80),
            categoryErrImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            categoryErrImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func constraitsCategoryErrLabel() {
        NSLayoutConstraint.activate([
            categoryErrLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            categoryErrLabel.topAnchor.constraint(equalTo: categoryErrImage.bottomAnchor, constant: 8)
        ])
    }
    
    private func constraitsCategoryButton() {
        NSLayoutConstraint.activate([
            categoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            categoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            categoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 60)

        ])
    }
}
