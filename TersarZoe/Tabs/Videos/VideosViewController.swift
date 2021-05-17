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
        tableView.backgroundColor = UIColor(hexString: "E8DED1")
        configureNavBar()
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
    private func configureNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "900603")
        navigationItem.title = "Videos"
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "More"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.addTarget(self, action: #selector(moreBtnTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    @objc
    func moreBtnTapped() {
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
