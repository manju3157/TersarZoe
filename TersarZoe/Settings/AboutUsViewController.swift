//
//  AboutUsViewController.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 17/05/21.
//

import UIKit

class AboutUsViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imgView: CircularImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConstants.appBgColor
        textView.backgroundColor = ColorConstants.appBgColor
        textView.textColor = ColorConstants.navBarColor
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(.zero, animated: false)
    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
