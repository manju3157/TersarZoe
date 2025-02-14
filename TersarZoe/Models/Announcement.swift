//
//  Announcement.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 17/05/21.
//

import Foundation

class Announcement: Codable {
    var announcements: [AnnouncementPost]
}

class AnnouncementPost: Codable {
    var id: Int
    var title: String
    var description: String
    var is_youtube: Int
    var youtube_url: String?
    var created_at: String?
    var files: [TZFile]

    var isAYouTubeVideo: Bool {
           return is_youtube == 1
       }
}
