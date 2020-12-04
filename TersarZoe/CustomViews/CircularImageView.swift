//
//  CircularImageView.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 18/11/20.
//

import Foundation
import UIKit

class CircularImageView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentMode = .scaleAspectFill
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2.0
        layer.masksToBounds = true
    }
}
