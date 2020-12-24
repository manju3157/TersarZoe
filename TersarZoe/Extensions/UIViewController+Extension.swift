//
//  UIViewController+Extension.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 24/12/20.
//

import Foundation
import UIKit

extension UIViewController {
    func hasNetworkConnection() -> Bool {
        let reachability = Reachability.forInternetConnection()
        let reachabilityStatus: NetworkStatus = reachability!.currentReachabilityStatus()
        return NotReachable != reachabilityStatus
    }
}
