//
//  CharacterViewController.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-24.
//  Copyright © 2019 Vince. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var status: UILabel!
    @IBOutlet private weak var species: UILabel!
    @IBOutlet private weak var type: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var origin: UILabel!
    @IBOutlet private weak var location: UILabel!

    var character: Character!

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = character.name
        species.text = character.species
        type.text = character.type
        gender.text = character.gender
        origin.text = character.characterOrigin.name
        location.text = character.characterLocation.name
        Services.shared.image.loadImage(url: character.image) { [weak self] (result) in
            if case .success(let image, _) = result {
                self?.profileImage.image = image
            }
        }

        status.text = character.characterStatus.rawValue
        switch character.characterStatus {
        case .alive:
            status.textColor = .green
        case .dead:
            status.textColor = .red
        case .unknown:
            break
        }
    }
}

