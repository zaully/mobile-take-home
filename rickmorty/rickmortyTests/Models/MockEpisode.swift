//
//  MockEpisode.swift
//  rickmortyTests
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation
@testable import rickmorty

class MockEpisode: Episode {
    var id: Int = 0

    var name: String = ""

    var airDate: String = ""

    var episode: String = ""

    var characters: [String] = []
}
