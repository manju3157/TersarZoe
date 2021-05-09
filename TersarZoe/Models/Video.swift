//
//  Video.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 09/05/21.
//

import Foundation

class Video: Codable {
    var id: Int
    var title: String
    var youtube_url: String

    init(id: Int, title: String, youtube_url: String) {
        self.id = id
        self.title = title
        self.youtube_url = youtube_url
    }
}

class VideoList: Codable {
    var id: Int
    var name: String
    var posts: [Video]
}

class VideoCategory: Codable {
    var sub_category: VideoList
}
