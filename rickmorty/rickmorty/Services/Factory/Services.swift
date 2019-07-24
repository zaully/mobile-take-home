//
//  Services.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-22.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

class Services {
    static let shared = Services()

    lazy var image: ImageService = ImageServiceImpl(session: URLSession.shared, thread: thread)
    lazy var episode: EpisodeService = EpisodeServiceImpl(http: http)
    lazy var character: CharacterService = CharacterServiceImpl(http: http)

    private init() {}

    private let thread: Thread = DispatchWrapper()
    private lazy var http: HttpService = HttpServiceImpl(session: URLSession.shared, thread: thread)
}
