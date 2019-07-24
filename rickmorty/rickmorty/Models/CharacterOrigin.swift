//
//  CharacterOrigin.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

protocol CharacterOrigin: class {
    var name: String { get }
    var url: String { get }
}

class CharacterOriginModel: CharacterOrigin, Codable {
    let name: String
    let url: String
}
