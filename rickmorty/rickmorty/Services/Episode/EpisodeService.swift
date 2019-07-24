//
//  EpisodeService.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-22.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

enum EpisodeLoadAllResult {
    case success(episodes: [Episode], episodeCount: Int, page: Int, pageCount: Int)
    case failed(error: Error)
}

protocol EpisodeService: class {
    func loadEpisodes(for page: Int, completion: ((EpisodeLoadAllResult) -> Void)?)
}

class EpisodeServiceImpl: EpisodeService {
    private let http: HttpService
    private let decoder: JSONDecoder = JSONDecoder()
    private var requesting = [Int: [((EpisodeLoadAllResult) -> Void)?]]()

    init(http: HttpService) {
        self.http = http
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func loadEpisodes(for page: Int, completion: ((EpisodeLoadAllResult) -> Void)?) {
        guard requesting[page] == nil else {
            requesting[page]?.append(completion)
            return
        }
        requesting[page] = [completion]
        http.request(url: "https://rickandmortyapi.com/api/episode?page=\(page + 1)", method: .get) { (result) in
            switch result {
            case .failure(let error):
                completion?(.failed(error: error))
            case .success(let json):
                self.handleResponse(json: json, for: page)
            }
        }
    }
}

extension EpisodeServiceImpl {
    func handleResponse(json: [String: Any], for page: Int) {
        let items = (json["results"] as? [Any] ?? []).compactMap({ (episodeJson) -> Episode? in
            if let data = try? JSONSerialization.data(withJSONObject: episodeJson),
                let episode = try? self.decoder.decode(EpisodeModel.self, from: data) {
                return episode
            }
            return nil
        })
        let info = json["info"] as? [String: Any]
        let count = info?["count"] as? Int ?? 0
        let pages = info?["pages"] as? Int ?? 0
        let success = EpisodeLoadAllResult.success(episodes: items, episodeCount: count, page: page, pageCount: pages)
        let completions = self.requesting[page] ?? []
        self.requesting[page] = nil
        for completion in completions {
            completion?(success)
        }
    }
}
