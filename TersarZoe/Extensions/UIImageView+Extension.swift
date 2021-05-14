//
//  UIImageView+Extension.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 14/05/21.
//

import Foundation
import UIKit

extension UIImageView {
   func makeRoundCorners(byRadius rad: CGFloat) {
      self.layer.cornerRadius = rad
      self.clipsToBounds = true
   }
}
