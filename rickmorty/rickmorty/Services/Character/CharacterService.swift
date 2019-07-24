//
//  CharacterService.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import Foundation

enum GetCharacterResult {
    case success(character: Character)
    case failure(error: Error)
}

protocol CharacterService: class {
    func getCharacter(with url: String) -> Character?
    func loadCharacter(with url: String, completion: ((GetCharacterResult) -> Void)?)
}

class CharacterServiceImpl: CharacterService {

    private let http: HttpService
    private let decoder: JSONDecoder = JSONDecoder()
    private var cache = [String: CharacterModel]()

    init(http: HttpService) {
        self.http = http
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func getCharacter(with url: String) -> Character? {
        return cache[url]
    }

    func loadCharacter(with url: String, completion: ((GetCharacterResult) -> Void)?) {
        if let cached = cache[url] {
            completion?(.success(character: cached))
            return
        }
        http.request(url: url, method: .get) { (result) in
            switch result {
            case .failure(let error):
                completion?(.failure(error: error))
            case .success(let json):
                if let data = try? JSONSerialization.data(withJSONObject: json),
                    let character = try? self.decoder.decode(CharacterModel.self, from: data) {
                    self.cache[url] = character
                    completion?(.success(character: character))
                } else {
                    completion?(.failure(error: HttpServiceError.invalidResponse))
                }
            }
        }
    }
}
