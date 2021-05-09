//
//  BaseViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 09/05/21.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showAlert(alertMessage: String) {
        let alert = UIAlertController(title: "TersarZoe", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    /// Show alert indicating no internet.
    func showNoInternetConnectionAlert() {
        self.showAlert(alertMessage: "No internet connection. Please try again!")
    }

}
