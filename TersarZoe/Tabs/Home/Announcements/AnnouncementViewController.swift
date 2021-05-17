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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Announcements"
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

    }

}
