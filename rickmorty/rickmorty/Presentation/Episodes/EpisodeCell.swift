//
//  EpisodeCell.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-22.
//  Copyright © 2019 Vince. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    @IBOutlet private weak var code: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var airDate: UILabel!
    @IBOutlet private weak var characterCount: UILabel!

    func config(with episode: Episode?) {
        code.text = episode?.episode
        name.text = episode?.name
        if let episode = episode {
            airDate.text = "Aired on ".localized + episode.airDate
            characterCount.text = "\(episode.characters.count)" + " Characters".localized
        } else {
            airDate.text = nil
            characterCount.text = nil
        }
    }
}
