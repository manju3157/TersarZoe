//
//  CommonCollectionViewCell.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 11/05/21.
//

import UIKit

class CommonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        contentView.layer.cornerRadius = 8.0
    }

    func populateCell(sc: SubCategory) {
        nameLbl.text = sc.name
        if let url = URL(string: sc.banner_image_url) {
            imgView.sd_setImage(with: url, completed: nil)
        }
    }
}