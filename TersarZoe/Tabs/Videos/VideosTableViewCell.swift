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
        testView.layer.cornerRadius = 16.0
        // Initialization code
        testView.loadWithVideoId("2otxSV4rm7s")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
