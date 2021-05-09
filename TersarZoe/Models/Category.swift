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

    init(id: Int, name: String, banner_image_url: String) {
        self.id = id
        self.name = name
        self.banner_image_url = banner_image_url
    }
}

class CategoryList: Codable {
    var categories: [Category]
}
