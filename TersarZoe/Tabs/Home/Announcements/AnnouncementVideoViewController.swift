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
        view.backgroundColor = UIColor(hexString: "E8DED1")
        youtubeView.backgroundColor = UIColor(hexString: "E8DED1")
        textView.backgroundColor = UIColor(hexString: "E8DED1")
    }
}
