//
//  Thread.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-22.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

enum ThreadType {
    case main
    case background
}

protocol Thread: class {
    func run(_ execution: (() -> Void)?, on: ThreadType)
}

class DispatchWrapper: Thread {
    func run(_ execution: (() -> Void)?, on: ThreadType) {
        let queue: DispatchQueue
        switch on {
        case .main:
            queue = .main
        case .background:
            queue = .global(qos: .userInitiated)
        }
        queue.async {
            execution?()
        }
    }
}
