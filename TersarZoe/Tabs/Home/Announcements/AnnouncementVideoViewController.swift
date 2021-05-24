//
//  AnnouncementVideoViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 17/05/21.
//

import UIKit
import YoutubePlayerView

class AnnouncementVideoViewController: BaseViewController {
    @IBOutlet weak var youtubeView: YoutubePlayerView!
    @IBOutlet weak var textView: UITextView!

    var announcementPost: AnnouncementPost?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if hasNetworkConnection() {
            if let announcement = announcementPost, let videoUrl = announcement.youtube_url {
                youtubeView.loadWithVideoId(videoUrl)
                textView.text = announcement.description
            }
        } else {
            textView.text = announcementPost?.description ?? ""
            showNoInternetConnectionAlert()
        }
    }
    private func configureUI() {
        let bgColor = ColorConstants.appBgColor
        view.backgroundColor = bgColor
        youtubeView.backgroundColor = bgColor
        textView.backgroundColor = bgColor
    }
}
