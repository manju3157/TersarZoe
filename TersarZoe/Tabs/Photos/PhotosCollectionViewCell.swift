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
        // Initialization code
    }
    func populateCell(photo: Photo) {
        nameLbl.text = photo.name
        if let url = URL(string: photo.banner_image_url) {
            imgView.sd_setImage(with: url, completed: nil)
        }
    }
}
