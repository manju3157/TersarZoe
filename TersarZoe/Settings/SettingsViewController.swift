//
//  SettingsViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 28/11/20.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsLbl: UILabel!

    var menuItems: [String] = ["About Us", "Share NamkhaZoe App",
                               "Feedback", "Donation",
                               "Related Website"]
    var menuImages: [UIImage?] = [UIImage(named: "AboutUS"), UIImage(named: "ShareApp"),
                                  UIImage(named: "Feedback"), UIImage(named: "Donation"),
                                  UIImage(named: "Announcement")]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        settingsLbl.textColor = ColorConstants.navBarColor
        self.view.backgroundColor = ColorConstants.appBgColor
        tableView.backgroundColor = ColorConstants.appBgColor
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    private func composeMail() {
        let mailComposeViewController = configureMailComposer()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            print("Can't send email")
        }
    }
    private func configureMailComposer() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["dundul.rapten@gmail.com"])
        mailComposeVC.setSubject("Feedback NamkhaZoe iOS")
        mailComposeVC.setMessageBody(getDeviceInfo(), isHTML: false)
        return mailComposeVC
    }
    //MARK: - MFMail compose method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    private func getDeviceInfo() -> String {
        let os = "OS: " + UIDevice.current.systemVersion
        let deviceName = "Device: " + UIDevice.current.name
        let appName = "App: " + (Bundle.main.displayName ?? "")
        let version = "Version: " + AppUtils.buildAndVersion()

        return os + "\n" + deviceName + "\n" + appName + "\n" + version
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
        cell?.contentView.backgroundColor = ColorConstants.appBgColor
        cell?.fillMenu(name: menuItems[indexPath.row], image: menuImages[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  indexPath.row {
        case 0:
            performSegue(withIdentifier: "ShowAboutUs", sender: nil)
        case 1:
            let text = "Download Tersar App " + "http://onelink.to/efgf76"
            let shareVC = ShareManager.current.getShareController(textToShare: text, view: self.view)
            present(shareVC, animated: true, completion: nil)
        case 2:
            composeMail()
        case 3:
            performSegue(withIdentifier: "ShowDonation", sender: nil)
        case 4:
            performSegue(withIdentifier: "ShowRelatedWebsite", sender: nil)
        default:
            return
        }
    }
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
