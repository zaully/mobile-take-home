//
//  Character.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

enum CharacterStatus: String {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
}

protocol Character: class {
    var id: Int { get }
    var name: String { get }
    var characterStatus: CharacterStatus { get set }
    var species: String { get }
    var type: String { get }
    var gender: String { get }
    var image: String { get }
    var characterOrigin: CharacterOrigin { get }
    var characterLocation: CharacterLocation { get }

    var speciesAndTypeOrGender: String { get }
    var canBeKilled: Bool { get }
}

class CharacterModel: Character, Codable {
    let id: Int
    let name: String
    var status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let origin: CharacterOriginModel
    let location: CharacterLocationModel
}

extension CharacterModel {

    var characterStatus: CharacterStatus {
        get {
            return CharacterStatus(rawValue: status) ?? .unknown
        }
        set {
            status = newValue.rawValue
        }
    }

    var characterOrigin: CharacterOrigin {
        return origin
    }

    var characterLocation: CharacterLocation {
        return location
    }

    var speciesAndTypeOrGender: String {
        return species + " " + (type.isEmpty ? gender : type)
    }

    var canBeKilled: Bool {
        return characterStatus != .dead
    }
}
