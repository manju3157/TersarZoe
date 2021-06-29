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
        if UIDevice.current.userInterfaceIdiom == .phone {
            activityViewController.popoverPresentationController?.permittedArrowDirections = .any
            activityViewController.popoverPresentationController?.sourceView = view
            return activityViewController
        } else {
            if let popoverController = activityViewController.popoverPresentationController {
                   popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: 0, height: 0)
                   popoverController.sourceView = view
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
               }
            return activityViewController
        }
    }
}
