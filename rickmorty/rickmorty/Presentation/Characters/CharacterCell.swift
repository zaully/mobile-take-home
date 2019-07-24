//
//  CharacterCell.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {

    @IBOutlet private weak var background: UIView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var profile: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var status: UILabel!
    @IBOutlet private weak var species: UILabel!
    private var loadingImage: String?

    override func prepareForReuse() {
        super.prepareForReuse()
        loadingImage = nil
        profile.image = nil
        background.backgroundColor = nil
    }

    func config(_ character: Character?) {
        if let char = character {
            name.text = char.name
            status.text = char.characterStatus.rawValue
            species.text = char.speciesAndTypeOrGender
            container.isHidden = false
            spinner.stopAnimating()
            loadingImage = char.image
            Services.shared.image.loadImage(url: char.image) { [weak self] (result) in
                if case .success(let image, let url) = result, url == self?.loadingImage {
                    self?.profile.image = image
                }
            }
            background.backgroundColor = char.characterStatus == .dead ? .red : nil

        } else {
            spinner.startAnimating()
            container.isHidden = true
        }
    }
}
