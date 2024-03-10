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
        label.text = NSLocalizedString("category.label", comment: "")
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
        label.attributedText = NSMutableAttributedString(string: NSLocalizedString("category.null.title", comment: ""), attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        view.addSubview(label)
        return label
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.backgroundColor = .ypBlack
        button.setTitle(NSLocalizedString("category.add.button", comment: ""), for: .normal)
        button.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    private lazy var categoryTableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.cellIdentifer)
        tableView.separatorStyle = .singleLine
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        return tableView
    }()
    //MARK: - viewModel
    private var viewModel: CategoryViewModelProtocol!
    //MARK: - delegate
    weak var delegate: CategoryViewControllerDelegate?
    //MARK: - public
    var selectedCategory: String?
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypWhite
        self.viewModel = CategoryViewModel()
        bind()
        
        constraitsCategoryLabel()
        constraitsCategoryErrImage()
        constraitsCategoryErrLabel()
        constraitsCategoryButton()
        constraitCategoryTableView()
        categoryTableView.isHidden = viewModel.categoryNames.count == 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        categoryTableView.reloadData()
    }
    //MARK: - private func
    
    private func bind() {
        viewModel.visibleCategoriesBinding = { [weak self] _ in
            guard let self = self else { return }
            self.categoryTableView.reloadData()
            categoryTableView.isHidden = viewModel.categoryNames.count == 0
        }
    }
    //MARK: - OBJC
    @objc private func didTapCategoryButton(_ sender: UIButton) {
        let view = NewCategoryViewController()
        view.delegate = self
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
    
    private func constraitCategoryTableView() {
        NSLayoutConstraint.activate([
            categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryTableView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 38),
            categoryTableView.bottomAnchor.constraint(equalTo: categoryButton.topAnchor, constant: -39)
        ])
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categoryNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellIdentifer, for: indexPath) as? CategoryCell else {
            assertionFailure("Не удалось выполнить приведение к SettingsHabitOrEventCell")
            return UITableViewCell()
        }
        
        let categoryName = viewModel.categoryNames[indexPath.row]
        
        cell.isCellHidden(true)
        cell.layer.cornerRadius = 0
        cell.layer.maskedCorners = []
        cell.clipsToBounds = false
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        cell.textLabel?.text = categoryName
        
        if categoryName == selectedCategory {
            cell.isCellHidden(false)
        }
        
        if viewModel.categoryNames.count == 1 {
            if cell.textLabel?.text ?? "" == viewModel.categoryNames.first {
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 1000)
                cell.clipsToBounds = true
            }
        } else {
            if cell.textLabel?.text ?? "" == viewModel.categoryNames.first {
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                cell.clipsToBounds = true
            } else {
                if cell.textLabel?.text ?? "" == viewModel.categoryNames.last  {
                    cell.layer.cornerRadius = 16
                    cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 1000)
                    
                    cell.clipsToBounds = true
                }
            }
        }
        
  
         
        cell.backgroundColor = .ypBackground
        return cell
    }
}
// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryCell {
            cell.isCellHidden(false)
            delegate?.setSelectedCategory(categoryName: cell.textLabel?.text )
            self.dismiss(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryCell {
            cell.isCellHidden(true)
        }
    }
}
// MARK: - UITableViewDelegate
extension CategoryViewController: NewCategoryViewControllerDelegate {
    func addNewCategory(categoryName: String) {
        viewModel.addCategory(categoryTitle: categoryName)

    }
}
