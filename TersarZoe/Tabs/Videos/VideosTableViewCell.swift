//
//  VideosTableViewCell.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 05/12/20.
//

import UIKit
import YoutubePlayerView

class VideosTableViewCell: UITableViewCell {
    @IBOutlet weak var testView: YoutubePlayerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        testView.layer.masksToBounds = true
        testView.layer.cornerRadius = 16.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
