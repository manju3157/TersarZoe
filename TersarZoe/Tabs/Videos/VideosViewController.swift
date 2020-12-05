//
//  VideosViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 22/11/20.
//

import UIKit

class VideosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "VideosTableViewCell", bundle: nil), forCellReuseIdentifier: "VideosCell")
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationItem.title = "TersarZoe"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(addTapped))

    }

    @objc
    func addTapped() {
        print("Right Bar button")
        self.performSegue(withIdentifier: "VideoSettings", sender: self)
    }

}

extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideosCell") as? VideosTableViewCell
        return cell ?? UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
