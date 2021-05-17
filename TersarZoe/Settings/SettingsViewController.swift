//
//  SettingsViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 28/11/20.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var menuItems: [String] = ["About Us", "Share NamkhaZoe App", "Feedback"]
    var menuImages: [UIImage?] = [UIImage(named: "AboutUS"), UIImage(named: "ShareApp"), UIImage(named: "Feedback")]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuTableViewCell
        cell?.fillMenu(name: menuItems[indexPath.row], image: menuImages[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "showPDFItems", sender: nil)
    }
    
}
