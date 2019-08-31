//
//  RedditClientManager.swift
//  RedditClient
//
//  Created by German Buela on 31/08/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import Foundation

typealias FetchCompletion = (Result<ResponseModel, Error>) -> Void

enum FetchType {
    case top
    case next
}

struct FetchError: Error {
    let message: String
}

class RedditClientManager {
    
    private let maxPosts = 50
    
    private(set) var nextPageId: String?
    private(set) var posts: [Post] = []
    
    var nextPageAvailable: Bool {
        return true // FIXME: implement
    }
    
    func fetch(type: FetchType, completion: @escaping FetchCompletion) {
        guard let api = api(fetchType: type) else {
            completion(.failure(FetchError(message: "Something failed")))
            return
        }
        Networking.execute(api: api) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let any):
                if let data = any as? Data,
                    let response = try? JSONDecoder().decode(ResponseModel.self, from: data) {
                    completion(.success(response))
                } else {
                    completion(.failure(FetchError(message: "Unknown reponse")))
                }
            }
        }
    }
    
    private func api(fetchType: FetchType) -> RedditAPI? {
        switch fetchType {
        case .top:
            return .top
        case .next:
            guard maxPosts > posts.count,
                let pageId = nextPageId else {
                    return nil
            }
            return .next(after: pageId, count: maxPosts - posts.count)
        }
    }
}
