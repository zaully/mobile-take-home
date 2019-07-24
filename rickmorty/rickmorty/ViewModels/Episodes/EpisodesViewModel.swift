//
//  EpisodesViewModel.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-22.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

enum EpisodesViewEvent {
    case error(Error)
    case insert(itemCount: Int, startIndex: Int)
}

protocol EpisodesView: class {
    func handle(viewEvent: EpisodesViewEvent)
}

protocol EpisodesViewModel: class {
    var view: EpisodesView? { get set }
    var episodeCount: Int { get }
    func getEpisode(index: Int) -> Episode?
    func loadMore()
}

class EpisodesViewModelImpl: EpisodesViewModel {
    weak var view: EpisodesView? {
        didSet {
            loadMore()
        }
    }

    var episodeCount: Int {
        return episodes.count
    }

    private let service: EpisodeService
    private var episodes: [Episode] = []
    private var loaded = -1
    private var loading: Int?
    private var totalPages = 1

    init(service: EpisodeService) {
        self.service = service
    }

    func getEpisode(index: Int) -> Episode? {
        if index >= 0, index < episodeCount {
            return episodes[index]
        }
        return nil
    }

    func loadMore() {
        let toLoad = loaded + 1
        guard toLoad < totalPages, loading == nil else { return }
        loading = toLoad
        service.loadEpisodes(for: toLoad) { [weak self] (result) in
            switch result {
            case .failed(let error):
                self?.view?.handle(viewEvent: .error(error))
            case .success(let episodes, _, let page, let pageCount):
                self?.handleSuccess(episodes: episodes, page: page, totalPages: pageCount)
            }
        }
    }
}

private extension EpisodesViewModelImpl {
    func handleSuccess(episodes: [Episode], page: Int, totalPages: Int) {
        let startIndex = episodeCount
        self.episodes.append(contentsOf: episodes)
        self.loaded = page
        self.totalPages = totalPages
        loading = nil
        view?.handle(viewEvent: .insert(itemCount: episodes.count, startIndex: startIndex))
    }
}
