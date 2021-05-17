//
//  AnnouncementViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 17/05/21.
//

import UIKit

class AnnouncementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.shared.getAnnouncements { (status, announcementsList) in
            print("Announcements : \(announcementsList.count)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
