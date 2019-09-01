//
//  Post.swift
//  RedditClient
//
//  Created by German Buela on 31/08/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let name: String
    let createdUtc: Double
    let title: String
    let author: String
    let numComments: Int
    let thumbnailUrl: String?
    let thumbnailHeight: Int?
    let thumbnailWidth: Int?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case createdUtc = "created_utc"
        case title
        case author
        case numComments = "num_comments"
        case thumbnailUrl = "thumbnail"
        case thumbnailHeight = "thumbnail_height"
        case thumbnailWidth = "thumbnail_width"
        case url
    }
}
