//
//  AnnouncementViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 17/05/21.
//

import UIKit
import SVProgressHUD

class AnnouncementViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    var announcements: [AnnouncementPost] = []
    var selectedAnnouncement: AnnouncementPost?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Announcements"
        tableView.backgroundColor = UIColor(hexString: "E8DED1")
        tableView.register(UINib(nibName: "AnnouncementTableViewCell", bundle: nil), forCellReuseIdentifier: "AnnouncementCell")
        if hasNetworkConnection() {
            fetchAnnouncements()
        } else {
            super.showNoInternetConnectionAlert()
        }
    }

    private func fetchAnnouncements() {
        SVProgressHUD.showInfo(withStatus: "Fetching...")
        NetworkManager.shared.getAnnouncements {[weak self] (status, announcementsList) in
            print("Announcements : \(announcementsList.count)")
            SVProgressHUD.dismiss()
            if status && !announcementsList.isEmpty {
                self?.announcements = announcementsList
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAnnouncementVideos" {
            if let nextViewController = segue.destination as? AnnouncementVideoViewController {
                nextViewController.announcementPost = selectedAnnouncement
            }
        } else if segue.identifier == "ShowAnnouncementPhotos" {
            if let nextViewController = segue.destination as? AnnouncementPhotoViewController {
                nextViewController.announcementPost = selectedAnnouncement
            }
        }
    }
}

extension AnnouncementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell") as? AnnouncementTableViewCell
        cell?.populateCell(post: announcements[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announcement = announcements[indexPath.row]
        selectedAnnouncement = announcement
        if announcement.isAYouTubeVideo {
            performSegue(withIdentifier: "ShowAnnouncementVideos", sender: nil)
        } else {
            performSegue(withIdentifier: "ShowAnnouncementPhotos", sender: nil)
        }
    }

}
