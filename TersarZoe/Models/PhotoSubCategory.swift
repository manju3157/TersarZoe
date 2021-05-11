//
//  PhotoSubCategory.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 11/05/21.
//

import Foundation

class PhotoSubCategory: Codable {
    var sub_category: PhotoSubCategoryDetails
}

class PhotoSubCategoryDetails: Codable {
    var id: Int
    var name: String
    var posts: [PhotoPost]
}

class PhotoPost: Codable {
    var id: Int
    var title: String
    var thumbnail_url: String
    var files: [PhotoFile]
}

class PhotoFile: Codable {
    var id: Int
    var file_url: String
}
