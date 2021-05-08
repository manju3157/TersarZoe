//
//  Photo.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 08/05/21.
//

import Foundation

class Photo: Codable {
    var id: Int
    var name: String
    var banner_image_url: String
}

class PhotoList: Codable {
    var id: Int
    var name: String
    var sub_categories: [Photo]
}

class PhotoCategory: Codable {
    var category: PhotoList
}




