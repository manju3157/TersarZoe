//
//  PhotosCollectionViewCell.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 03/12/20.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.makeRoundCorners(byRadius: 10.0)
        contentView.applyCornerRadius(10.0)
        contentView.backgroundColor = ColorConstants.appBgColor
        nameLbl.textColor = ColorConstants.navBarColor
        layoutIfNeeded()
    }
    func populateCell(sc: MainSubCategory) {
        nameLbl.text = sc.name
        if let url = URL(string: sc.banner_image_url) {
            imgView.sd_setImage(with: url, completed: nil)
        }
    }
}
