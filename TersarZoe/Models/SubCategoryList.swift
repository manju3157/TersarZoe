//
//  PhotoSubCategory.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 11/05/21.
//

import Foundation

class SubCategorySet: Codable {
    var sub_category: SubCategoryListDetails
}

class SubCategoryListDetails: Codable {
    var id: Int
    var name: String
    var posts: [TZPost]
}

class TZPost: Codable {
    var id: Int
    var title: String
    var thumbnail_url: String
    var files: [TZFile]
}

class TZFile: Codable {
    var id: Int
    var file_url: String
}
