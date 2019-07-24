//
//  Episode.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-22.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

protocol Episode: class {
    var id: Int { get }
    var name: String { get }
    var airDate: String { get }
    var episode: String { get }
    var characters: [String] { get }
}

class EpisodeModel: Episode, Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
}
