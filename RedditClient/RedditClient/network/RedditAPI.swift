//
//  RedditAPI.swift
//  RedditClient
//
//  Created by German Buela on 31/08/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import Foundation

fileprivate let baseUrl = "https://www.reddit.com/top.json?limit=50"

enum RedditAPI {
    case top
    case next(after: String, count: Int)
}

extension RedditAPI: API {
    func makeRequest() -> URLRequest? {
        switch self {
        case .top:
            return buildRequest()
        case .next(let after, let count):
            return buildRequest(query: "after=\(after)&count=\(count)")
        }
    }
    
    private func buildRequest(query: String? = nil) -> URLRequest? {
        guard let url = URL(string: baseUrl + "&" + (query ?? "")) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
