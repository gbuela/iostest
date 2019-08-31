//
//  Networking.swift
//  RedditClient
//
//  Created by German Buela on 31/08/2019.
//  Copyright © 2019 German Buela. All rights reserved.
//

import Foundation

struct NetworkingError: Error {
    let message: String
}

typealias NetworkCompletion = (Result<Any, NetworkingError>) -> Void

struct Networking {
    static func execute(api: API, completion: @escaping NetworkCompletion) {
        guard let request = api.makeRequest() else {
            completion(.failure(NetworkingError(message: "can't create request")))
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            guard error == nil else {
                completion(.failure(NetworkingError(message: "request failed")))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkingError(message: "no data")))
                return
            }
            completion(.success(data))
        }
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
