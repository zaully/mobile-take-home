//
//  MockEpisodeService.swift
//  rickmortyTests
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation
@testable import rickmorty

class MockEpisodeService: EpisodeService {
    var loadEpisodesMock: ((Int, ((EpisodeLoadAllResult) -> Void)?) -> Void)?
    func loadEpisodes(for page: Int, completion: ((EpisodeLoadAllResult) -> Void)?) {
        loadEpisodesMock?(page, completion)
    }
}
