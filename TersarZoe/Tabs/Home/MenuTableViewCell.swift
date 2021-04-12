//
//  MenuTableViewCell.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 18/11/20.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgView: CircularImageView!
    @IBOutlet weak var ovalView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        ovalView.layer.cornerRadius = 8//28
        ovalView.backgroundColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setName(name: String) {
        nameLbl.text = name
    }
}
