//
//  ListingData.swift
//  RedditClient
//
//  Created by German Buela on 31/08/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import Foundation

struct ListingData: Decodable {
    let after: String
    let children: [Post]
}
