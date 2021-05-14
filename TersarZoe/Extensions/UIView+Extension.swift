//
//  UIView+Extension.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 14/05/21.
//

import Foundation
import UIKit

extension UIView {
    func applyShadow(color: UIColor = .black) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.masksToBounds = false
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 14.0
    }

    func applyCornerRadius(_ radius: CGFloat = 14.0) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
