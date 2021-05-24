//
//  AnnouncementTableViewCell.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 17/05/21.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var youTubeImgView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 14.0
        contentView.backgroundColor = ColorConstants.appBgColor
        containerView.backgroundColor = ColorConstants.appBgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func populateCell(post: AnnouncementPost) {
        nameLbl.text = post.title
        youTubeImgView.isHidden = !post.isAYouTubeVideo
        if post.isAYouTubeVideo {
            if let youtubeThumbnailURL = URL(string: getYoutubeThumbnailURL(videoID: post.youtube_url ?? "")) {
                imgView.sd_setImage(with: youtubeThumbnailURL, completed: nil)
            }
        } else {
            if let urlStr = post.files.first?.file_url, let url = URL(string: urlStr) {
                imgView.sd_setImage(with: url, completed: nil)
            }
        }
    }
    private func getYoutubeThumbnailURL(videoID: String) -> String {
        let thumbnailURLString = "https://img.youtube.com/vi/" + videoID  + "/hqdefault.jpg"
        return thumbnailURLString
    }
}
