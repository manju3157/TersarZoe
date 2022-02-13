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
        let ignoreCategoryNames = ["MP3 Teaching", "Video", "Photo"]
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let decodedResponse = try? JSONDecoder().decode(CategoryList.self, from: data) {
                        let actualCategories = decodedResponse.categories
                        var filteredCategories = actualCategories.filter { (category) -> Bool in
                            !ignoreCategoryNames.contains(category.name)
                        }
                        let announcementCat = Category(id: 999, name: "News and updates", banner_image_url: "")
                        filteredCategories.append(announcementCat)
                        responseCallback(true, filteredCategories)
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
        let videoPath = AppConstants.subCategoryBasePath + String(AppConstants.videoCategoryID)
        guard let url = URL(string: videoPath) else {
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

    func getAnnouncements(responseCallback: @escaping (Bool, [AnnouncementPost]) -> ()) {
        guard let url = URL(string: AppConstants.announcementsPath) else {
            print("Invalid URL")
            responseCallback(false, [])
            return
        }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let decodedResponse = try? JSONDecoder().decode(Announcement.self, from: data) {
                        let announcements = decodedResponse.announcements.sorted { (item1, item2) -> Bool in
                            item1.id < item2.id
                        }
                        responseCallback(true, announcements)
                        return
                    }
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            responseCallback(false, [])
        }.resume()
    }
}
