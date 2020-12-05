//
//  VideosTableViewCell.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 05/12/20.
//

import UIKit

class VideosTableViewCell: UITableViewCell {
    @IBOutlet weak var testView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        testView.layer.cornerRadius = 12.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
