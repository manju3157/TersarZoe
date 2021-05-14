//
//  MainCategory.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 14/05/21.
//

import Foundation

class MainCategory: Codable {
    var category: SubCategoryList
}

class SubCategoryList: Codable {
    var id: Int
    var name: String
    var sub_categories: [SubCategory]
}


