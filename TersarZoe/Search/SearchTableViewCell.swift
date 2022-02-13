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
    
    func populateCell(post: TZPost, subTitle: String, fileType: CommonContentType) {
        titleLbl.text = post.title
        subTitleLbl.text = subTitle
        switch fileType {
        case .pdf:
            imgView.setImage(UIImage(named: "PDF")!)
        case .audio:
            imgView.setImage(UIImage(named: "Audio")!)
        case .photo:
            imgView.setImage(UIImage(named: "Image")!)
        case .none:
            imgView.setImage(UIImage(named: "Announcement")!)
        }
    }
    
}
