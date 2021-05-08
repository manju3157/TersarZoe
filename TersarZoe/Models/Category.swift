//
//  Category.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 08/05/21.
//

import Foundation

class Category: Codable {
    var id: Int
    var name: String
    var banner_image_url: String
}

class CategoryList: Codable {
    var categories: [Category]
}
