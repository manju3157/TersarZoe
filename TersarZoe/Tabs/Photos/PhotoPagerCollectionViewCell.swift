//
//  PhotoPagerCollectionViewCell.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 13/05/21.
//

import UIKit
import SDWebImage

class PhotoPagerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func populateCell(photo: TZFile) {
        if let url = URL(string: photo.file_url) {
            imgView.sd_setImage(with: url, completed: nil)
        }
    }

}
