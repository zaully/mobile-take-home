//
//  HttpService.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-22.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

enum Method: String {
    case get = "GET"
}

enum HttpResult {
    case success(json: [String: Any])
    case failure(error: Error)
}

enum HttpServiceError: LocalizedError {
    case invalidRequestUrl
    case invalidResponse
}

protocol HttpService: class {
    func request(url: String, method: Method, completion: ((HttpResult) -> Void)?)
}

class HttpServiceImpl: HttpService {

    private let session: NetworkSession
    private let thread: Thread

    init(session: NetworkSession, thread: Thread) {
        self.session = session
        self.thread = thread
    }

    func request(url: String, method: Method, completion: ((HttpResult) -> Void)?) {
        guard let url = URL(string: url) else {
            completion?(.failure(error: HttpServiceError.invalidRequestUrl))
            return
        }
        let task = session.dataTask(with: url) { (data, _, error) in
            let result: HttpResult
            switch error {
            case .none:
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    result = .success(json: json)
                } else {
                    result = .failure(error: HttpServiceError.invalidResponse)
                }
            case .some(let error):
                result = .failure(error: error)
            }
            self.thread.run({
                completion?(result)
            }, on: .main)
        }
        task.resume()
    }
}

protocol NetworkSession: class {
    func dataTask(with: URL, completion: ((Data?, URLResponse?, Error?) -> Void)?) -> URLSessionDataTask
}

extension URLSession: NetworkSession {
    func dataTask(with: URL, completion: ((Data?, URLResponse?, Error?) -> Void)?) -> URLSessionDataTask {
        return dataTask(with: with, completionHandler: { (data, response, error) in
            completion?(data, response, error)
        })
    }
}
