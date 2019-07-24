//
//  CharacterLocation.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-24.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

protocol CharacterLocation: class {
    var name: String { get }
    var url: String { get }
}

class CharacterLocationModel: CharacterLocation, Codable {
    let name: String
    let url: String
}
