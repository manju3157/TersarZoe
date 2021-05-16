//
//  ShareManager.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 16/05/21.
//

import Foundation
import UIKit

class ShareManager {
    static let current = ShareManager()

    func getShareController(textToShare: String, view: UIView) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(
                                        activityItems: [textToShare],
                                        applicationActivities: nil
                                    )
        activityViewController.setValue("NamkhaZoe", forKey: "subject")
        activityViewController.popoverPresentationController?.permittedArrowDirections = .any
        activityViewController.popoverPresentationController?.sourceView = view
        return activityViewController
    }
}
