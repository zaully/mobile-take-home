//
//  CharactersViewModel.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

enum CharactersViewEvent {
    case error(Error)
    case didLoad(character: Character, forIndex: Int)
    case reload(index: Int)
}

protocol CharactersView: class {
    func handle(viewEvent: CharactersViewEvent)
}

protocol CharactersViewModel: class {
    var view: CharactersView? { get set }
    var totalCharacters: Int { get }
    func getCharacter(index: Int) -> Character?
    func killCharacter(at index: Int)
}

class CharactersViewModelImpl: CharactersViewModel {

    private let service: CharacterService
    private let characterUrls: [String]
    private var characters = [Int: Character]()

    weak var view: CharactersView?
    var totalCharacters: Int {
        return characterUrls.count
    }

    init(service: CharacterService, characterUrls: [String]) {
        self.service = service
        self.characterUrls = characterUrls
    }

    func getCharacter(index: Int) -> Character? {
        guard index >= 0, index < totalCharacters else { return nil }

        let url = characterUrls[index]
        if let found = service.getCharacter(with: url) {
            return found
        }
        service.loadCharacter(with: url) { [weak self] (result) in
            switch result {
            case .failure:
                break
            case .success(let character):
                self?.characters[index] = character
                self?.view?.handle(viewEvent: .didLoad(character: character, forIndex: index))
            }
        }
        return nil
    }

    func killCharacter(at index: Int) {
        guard index >= 0, index < totalCharacters else { return }
        if let found = service.getCharacter(with: characterUrls[index]), found.canBeKilled {
            found.characterStatus = .dead
            view?.handle(viewEvent: .reload(index: index))
        }
    }
}
