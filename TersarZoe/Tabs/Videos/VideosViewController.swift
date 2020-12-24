//
//  VideosViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 22/11/20.
//

import UIKit
import SVProgressHUD

class VideosViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var videoIDArray: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "VideosTableViewCell", bundle: nil), forCellReuseIdentifier: "VideosCell")
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationItem.title = "TersarZoe"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(addTapped))
        SVProgressHUD.show(withStatus: "Fetching...")
        Global.delay(2.0) {
            SVProgressHUD.dismiss()
            self.videoIDArray = ["IjtWtakwsjw", "tilBs32zN7I", "5yZ8a_zAEl0", "xlBEEuYIWwY", "eYKdEnEqfQQ", "Lxq-RiLb-6M", "IjtWtakwsjw", "8AeSsJGUGDA"]
            self.tableView.reloadData()
        }

        if hasNetworkConnection() {

        }
    }

    @objc
    func addTapped() {
        print("Right Bar button")
        self.performSegue(withIdentifier: "VideoSettings", sender: self)
    }

}

extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoIDArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideosCell") as? VideosTableViewCell
        cell?.testView.loadWithVideoId(videoIDArray[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
