//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 09.03.2024.
//

import Foundation
import UIKit


final class NewCategoryViewController: UIViewController {
//MARK: - UI
    private lazy var NewCategoryLabel : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("new.category.label", comment: "")
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var newCategoryTextField : UITextField = {
        let newCategoryTextField = UITextField()
        let paddingViewLeft: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        newCategoryTextField.leftView = paddingViewLeft
        newCategoryTextField.leftViewMode = .always
        
        newCategoryTextField.layer.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3).cgColor
        newCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        newCategoryTextField.placeholder = NSLocalizedString("new.category.placeholder", comment: "")
        newCategoryTextField.layer.cornerRadius = 16
        newCategoryTextField.clearButtonMode = .always
        newCategoryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                       for: .editingChanged)
        newCategoryTextField.addSubview(newCategoryErrLabel)
        view.addSubview(newCategoryTextField)
        newCategoryTextField.delegate = self
        return newCategoryTextField
    }()
    
    private lazy var newCategoryErrLabel : UILabel = {
        let errLabel = UILabel()
        errLabel.text = NSLocalizedString("placeholder.restrict.label", comment: "")
        errLabel.font = .systemFont(ofSize: 17)
        errLabel.textColor = .ypRed
        errLabel.translatesAutoresizingMaskIntoConstraints = false
        errLabel.textAlignment = .center
        errLabel.isHidden = true
        return errLabel
    }()
    
    private lazy var newCategoryButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.backgroundColor = .ypBlack
        button.setTitle(NSLocalizedString("new.category.button", comment: ""), for: .normal)
        button.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapNewCategoryButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    //MARK: - delegate
    weak var delegate: NewCategoryViewControllerDelegate?
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypWhite
        constraitsCategoryLabel()
        constraitsCategoryButton()
        constraitNewHabbitTextField()
        cancelKeyboardGestureSetup()
        updateButtonStatus()
    }
    
    //MARK: - PRIVATE
    private func cancelKeyboardGestureSetup() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func updateButtonStatus() {
        if newCategoryTextField.text?.count ?? 0 > 0  {
            newCategoryButton.isEnabled = true
            newCategoryButton.backgroundColor = .ypBlack
        } else {
            newCategoryButton.isEnabled = false
            newCategoryButton.backgroundColor = .ypGray
        }
    }

    //MARK: - CONSTRAITS
    private func constraitsCategoryLabel() {
        NSLayoutConstraint.activate([
            NewCategoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NewCategoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    private func constraitsCategoryButton() {
        NSLayoutConstraint.activate([
            newCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            newCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func constraitNewHabbitTextField() {
        NSLayoutConstraint.activate([
            newCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newCategoryTextField.topAnchor.constraint(equalTo: NewCategoryLabel.bottomAnchor, constant: 38),
            newCategoryTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
        constraitNewHabbitErrLabel()
    }
    
    private func constraitNewHabbitErrLabel() {
        NSLayoutConstraint.activate([
            newCategoryErrLabel.centerXAnchor.constraint(equalTo: newCategoryErrLabel.centerXAnchor),
            newCategoryErrLabel.topAnchor.constraint(equalTo: newCategoryTextField.bottomAnchor, constant: 8)
        ])
    }
    //MARK: - OBJC
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateButtonStatus()
    }
    
    @objc func didTapNewCategoryButton(_ sender: UIButton) {
        if let newCategoryName = newCategoryTextField.text {
            delegate?.addNewCategory(categoryName: newCategoryName)
        }
        self.dismiss(animated: true)
    }
    
    @objc func hideKeyboard() {
        self.newCategoryTextField.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension NewCategoryViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count ?? 0) +  (string.count - range.length) >= 38 {
            newCategoryErrLabel.isHidden = false
            return false
        }
        newCategoryErrLabel.isHidden = true
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        newCategoryErrLabel.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.newCategoryTextField.resignFirstResponder()
        return true
    }
}
