//
//  DonationViewController.swift
//  TersarZoe
//
//  Created by manjunath.ramesh on 14/10/21.
//

import UIKit

class DonationViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConstants.appBgColor
        textView.backgroundColor = ColorConstants.appBgColor
        textView.textColor = ColorConstants.navBarColor
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
