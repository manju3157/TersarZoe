//
//  DownloadManager.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 16/05/21.
//

import Foundation
import UIKit

class DownloadManager {
    static let current = DownloadManager()

    func downloadFile(contentType: CommonContentType, urlString: String, fileTitle: String, responseCallback: @escaping (Bool, String) -> ()) {
        do {
            if let url = URL(string: urlString) {
                let fileContentData = try Data(contentsOf: url)
                let folderName = getFolderName(contentType: contentType)
                let folderPath = getDocumentsDirectory().appendingPathComponent(folderName)
                createDirectoryIfNeeded(docURL: folderPath)
                let subPath = folderName + "/" + fileTitle + "." + url.pathExtension
                let destURl = getDocumentsDirectory().appendingPathComponent(subPath)
                print("Download Path: \(destURl.path)")
                try? fileContentData.write(to: destURl, options: .atomic)
                responseCallback(true, destURl.absoluteString)
            }
        }
        catch {
            print(error)
            responseCallback(false, "")
        }
    }

    private func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    private func createDirectoryIfNeeded(docURL: URL) {
        if !FileManager.default.fileExists(atPath: docURL.path) {
            do {
                try FileManager.default.createDirectory(atPath: docURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    private func getFolderName(contentType: CommonContentType) -> String {
        switch contentType {
            case .pdf:
                return "PDF"
            case .audio:
                return "Audio"
            case .photo:
                return "Photo"
            case .none:
                return "Misc"
        }
    }
}
