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
        guard let url = URL(string: AppConstants.categoryPath) else {
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
                    }
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            responseCallback(false, [])
        }.resume()
    }
}
