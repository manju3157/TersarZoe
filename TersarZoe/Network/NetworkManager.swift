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
    func getHomeTabCategories(responseCallback: @escaping (Bool, [Category]) -> ()) {
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

    func getSubCategoriesFor(categoryID: Int, responseCallback: @escaping (Bool, [MainSubCategory]) -> ()) {
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
                    if let decodedResponse = try? JSONDecoder().decode(MainCategory.self, from: data) {
                        responseCallback(true, decodedResponse.category.sub_categories)
                        return
                    }
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            responseCallback(false, [])
        }.resume()
    }

    func getSubCategoryDetail(subCategoryID: Int, responseCallback: @escaping (Bool, [TZPost]) -> ()) {
        let photosPath = AppConstants.subCategoryBasePath + String(subCategoryID)
        guard let url = URL(string: photosPath) else {
            print("Invalid URL")
            responseCallback(false, [])
            return
        }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let decodedResponse = try? JSONDecoder().decode(SubCategorySet.self, from: data) {
                        let orderedPosts = decodedResponse.sub_category.posts.sorted { (item1, item2) -> Bool in
                            item1.id < item2.id
                        }
                        responseCallback(true, orderedPosts)
                        return
                    }
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            responseCallback(false, [])
        }.resume()
    }

    func getVideos(responseCallback: @escaping (Bool, [Video]) -> ()) {
        guard let url = URL(string: AppConstants.videosPath) else {
            print("Invalid URL")
            responseCallback(false, [])
            return
        }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let decodedResponse = try? JSONDecoder().decode(VideoCategory.self, from: data) {
                        responseCallback(true, decodedResponse.sub_category.posts)
                        return
                    }
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            responseCallback(false, [])
        }.resume()
    }
}
