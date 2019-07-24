//
//  EpisodesViewModelTests.swift
//  rickmortyTests
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import XCTest
@testable import rickmorty

class EpisodesViewModelTests: XCTestCase {

    let service = MockEpisodeService()
    let view = MockEpisodesView()
    var vm: EpisodesViewModelImpl!

    override func setUp() {
        vm = EpisodesViewModelImpl(service: service)
    }

    func setupDefaultEpisodes() {
        service.loadEpisodesMock = { (_, completion) in
            completion?(.success(episodes: [MockEpisode(), MockEpisode()], episodeCount: 2, page: 0, pageCount: 1))
        }

    }

    func testLoadsEpisodesWhenSetup() {
        var checked = false
        service.loadEpisodesMock = { (page, _) in
            checked = true
            XCTAssertEqual(page, 0)
        }
        vm.view = view
        XCTAssert(checked)
    }

    func testLoadsEpisodesError() {
        service.loadEpisodesMock = { (_, completion) in
            completion?(.failure(error: HttpServiceError.invalidResponse))
        }
        var checked = false
        view.handleMock = { (event) in
            if case .error(let error) = event {
                checked = true
                XCTAssertEqual(HttpServiceError.invalidResponse.localizedDescription, error.localizedDescription)
            }
        }
        vm.view = view
        XCTAssert(checked)
    }

    func testGetEpisodes() {
        let ep1 = MockEpisode()
        let ep2 = MockEpisode()
        service.loadEpisodesMock = { (_, completion) in
            completion?(.success(episodes: [ep1, ep2], episodeCount: 2, page: 0, pageCount: 1))
        }
        vm.view = view
        XCTAssertNil(vm.getEpisode(index: -1))
        XCTAssert(vm.getEpisode(index: 0) === ep1)
        XCTAssert(vm.getEpisode(index: 1) === ep2)
        XCTAssertNil(vm.getEpisode(index: 2))

        XCTAssertEqual(2, vm.episodeCount)
    }

    func testSafelyLoadMore() {
        var callCount = 0
        var callback: ((EpisodeLoadAllResult) -> Void)?
        service.loadEpisodesMock = { (_, completion) in
            callback = completion
            callCount += 1
        }
        vm.view = view
        vm.loadMore()
        vm.loadMore()
        XCTAssertEqual(1, callCount)

        callback?(.success(episodes: [MockEpisode()], episodeCount: 3, page: 0, pageCount: 3))
        vm.loadMore()
        vm.loadMore()
        XCTAssertEqual(2, callCount)

        callback?(.success(episodes: [MockEpisode()], episodeCount: 3, page: 1, pageCount: 3))
        vm.loadMore()
        XCTAssertEqual(3, callCount)

        callback?(.success(episodes: [MockEpisode()], episodeCount: 3, page: 2, pageCount: 3))
        vm.loadMore()
        XCTAssertEqual(3, callCount)
    }
}

class MockEpisodesView: EpisodesView {

    var handleMock: ((EpisodesViewEvent) -> Void)?
    func handle(viewEvent: EpisodesViewEvent) {
        handleMock?(viewEvent)
    }
}
