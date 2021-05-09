//
//  VideosViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 22/11/20.
//

import UIKit
import SVProgressHUD

class VideosViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var videoArray: [Video] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "VideosTableViewCell", bundle: nil), forCellReuseIdentifier: "VideosCell")
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationItem.title = "TersarZoe"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(addTapped))
        if hasNetworkConnection() {
            fetchVideos()
        } else {
            super.showNoInternetConnectionAlert()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        // When network is restored and tabs are switched
        if videoArray.isEmpty && hasNetworkConnection() {
            fetchVideos()
        }
    }

    @objc
    func addTapped() {
        print("Right Bar button")
        self.performSegue(withIdentifier: "VideoSettings", sender: self)
    }

    private func fetchVideos() {
        SVProgressHUD.show(withStatus: "Fetching...")
        NetworkManager.shared.getVideos {[weak self] (status, videos) in
            SVProgressHUD.dismiss()
            if status && !videos.isEmpty {
                self?.videoArray = videos
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideosCell") as? VideosTableViewCell
        cell?.testView.loadWithVideoId(videoArray[indexPath.row].youtube_url)
        return cell ?? UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
