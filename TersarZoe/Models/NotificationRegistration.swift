//
//  NotificationRegistration.swift
//  TersarZoe
//
//  Created by manjunath.ramesh on 13/03/22.
//

import Foundation


class NotificationRegistration: Codable {
    var device_id: String
    var error: Bool
    var message: String

    init(device_id: String, error: Bool, message: String) {
        self.device_id = device_id
        self.error = error
        self.message = message
    }
}
