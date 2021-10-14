//
//  RelatedWebsiteViewController.swift
//  TersarZoe
//
//  Created by manjunath.ramesh on 14/10/21.
//

import UIKit

class RelatedWebsiteViewController: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConstants.navBarColor
        textView.backgroundColor = ColorConstants.navBarColor
        titleLbl.textColor = ColorConstants.appBgColor
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
