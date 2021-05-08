//
//  NetworkManager.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 24/12/20.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?

    // MARK: - Web Service Methods
    func getCategories(responseCallback: @escaping (Bool, [Category]) -> ()) {
        guard let url = URL(string: AppConstants.categoryBasePath) else {
            print("Invalid URL")
            responseCallback(false, [])
            return
        }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let decodedResponse = try? JSONDecoder().decode(CategoryList.self, from: data) {
                        responseCallback(true, decodedResponse.categories)
                        return
                    }
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            responseCallback(false, [])
        }.resume()
    }

    func getPhotos(categoryID: Int, responseCallback: @escaping (Bool, [Photo]) -> ()) {
        let photosPath = AppConstants.categoryBasePath + String(categoryID)
        guard let url = URL(string: photosPath) else {
            print("Invalid URL")
            responseCallback(false, [])
            return
        }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let decodedResponse = try? JSONDecoder().decode(PhotoCategory.self, from: data) {
                        responseCallback(true, decodedResponse.category.sub_categories)
                        return
                    }
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            responseCallback(false, [])
        }.resume()
    }
}
