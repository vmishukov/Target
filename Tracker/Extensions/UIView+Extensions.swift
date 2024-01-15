//
//  UIView+Extensions.swift
//  Tracker
//
//  Created by Vladislav Mishukov on 15.01.2024.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_
                     subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}

extension UIView {
    @discardableResult func edgesToSuperview() -> Self {
        guard let superview = superview else {
            fatalError("View не в иерархии!")
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        return self
    }
}
