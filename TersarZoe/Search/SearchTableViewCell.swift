//
//  SearchTableViewCell.swift
//  TersarZoe
//
//  Created by manjunath.ramesh on 02/02/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: CircularImageView!
    @IBOutlet weak var ovalView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ovalView.layer.cornerRadius = 30
        ovalView.backgroundColor = .white
        titleLbl.textColor = ColorConstants.navBarColor
        subTitleLbl.textColor = ColorConstants.navBarColor
        contentView.backgroundColor = ColorConstants.appBgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populateCell(post: TZPost) {
        titleLbl.text = post.title
        subTitleLbl.text = post.title
        imgView.setImage(UIImage(named: "Announcement")!)
    }
    
}
