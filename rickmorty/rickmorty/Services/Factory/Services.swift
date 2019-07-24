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

    lazy var http: HttpService = HttpServiceImpl(session: URLSession.shared, thread: self.thread)

    lazy var episode: EpisodeService = EpisodeServiceImpl(http: self.http)

    private init() {}

    private let thread: Thread = DispatchWrapper()
}
