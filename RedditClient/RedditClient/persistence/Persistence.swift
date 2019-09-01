//
//  Persistence.swift
//  RedditClient
//
//  Created by German Buela on 01/09/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import Foundation

struct Persistence {
    let readPostsKey = "readPosts"
    let defaults = UserDefaults.standard
    
    func addReadId(id: String) {
        guard var ids = defaults.array(forKey: readPostsKey) as? [String] else {
            defaults.set([id], forKey: readPostsKey)
            return
        }
        ids.append(id)
        defaults.set(ids, forKey: readPostsKey)
    }
    
    func isRead(id: String) -> Bool {
        guard let ids = defaults.array(forKey: readPostsKey) as? [String] else {
            return false
        }
        return ids.contains(id)
    }
}
