//
//  AppUtils.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 17/05/21.
//

import Foundation

class AppUtils: NSObject {
    class func buildVersion() -> String? {
        let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return buildVersion
    }

    class func build() -> String {
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        return build
    }

    class func buildIdentifier() -> String? {
        let buildIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
        return buildIdentifier
    }

    class func buildAndVersion() -> String {
        let buildAndVersion = (buildVersion() ?? "") + "(" + build() + ")"
        return buildAndVersion
    }

    @objc
    class func getDeviceLanguage() -> String {
        let preferredLanguage = Locale.preferredLanguages[0]
        let languageAndCountry = preferredLanguage.components(separatedBy: "-")
        let languageCode = (!languageAndCountry.isEmpty) ? languageAndCountry[0] : "en"
        return languageCode
    }
}
