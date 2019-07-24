//
//  ImageService.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-24.
//  Copyright © 2019 Vince. All rights reserved.
//

import UIKit

enum LoadImageResult {
    case failure(error: Error)
    case success(image: UIImage, for: String)
}

protocol ImageService: class {
    func loadImage(url: String, completion: ((LoadImageResult) -> Void)?)
}

class ImageServiceImpl: ImageService {

    private let session: NetworkSession
    private let thread: Thread
    private var cache = [String: UIImage]()

    init(session: NetworkSession, thread: Thread) {
        self.session = session
        self.thread = thread
    }

    func loadImage(url: String, completion: ((LoadImageResult) -> Void)?) {
        if let cached = cache[url] {
            completion?(.success(image: cached, for: url))
            return
        }
        guard let request = URL(string: url) else {
            completion?(.failure(error: HttpServiceError.invalidRequestUrl))
            return
        }
        let task = session.dataTask(with: request) { (data, _, error) in
            self.thread.run({
                let result: LoadImageResult
                switch error {
                case .none:
                    if let data = data, let image = UIImage(data: data) {
                        result = .success(image: image, for: url)
                        self.cache[url] = image
                    } else {
                        result = .failure(error: HttpServiceError.invalidResponse)
                    }
                case .some(let error):
                    result = .failure(error: error)
                }
                completion?(result)
            }, on: .main)
        }
        task.resume()
    }
}
