//
//  MenuTableViewCell.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 18/11/20.
//

import UIKit
import SDWebImage

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgView: CircularImageView!
    @IBOutlet weak var ovalView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        ovalView.layer.cornerRadius = 30
        ovalView.backgroundColor = .white
        nameLbl.textColor = ColorConstants.navBarColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func populateCell(category: Category) {
        nameLbl.text = category.name
        if let url = URL(string: category.banner_image_url) {
            imgView.sd_setImage(with: url, completed: nil)
        }
    }
    func fillMenu(name: String, image: UIImage?) {
        nameLbl.text = name
        if let img = image {
            imgView.setImage(img)
        }
    }
}
