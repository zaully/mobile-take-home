//
//  CharactersViewController.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-23.
//  Copyright © 2019 Vince. All rights reserved.
//

import UIKit

class CharactersViewController: UITableViewController {

    var characterUrls: [String]!
    var vm: CharactersViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        vm = CharactersViewModelImpl(service: Services.shared.character, characterUrls: characterUrls)
        vm.view = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.totalCharacters
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? CharacterCell  {
            cell.config(vm.getCharacter(index: indexPath.row))
        }
        return cell
    }
}

extension CharactersViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    }
}

extension CharactersViewController: CharactersView {
    func handle(viewEvent: CharactersViewEvent) {
        switch viewEvent {
        case .error(let error):
            show(error: error)
        case .didLoad(let character, let index):
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CharacterCell {
                cell.config(character)
            }
        }
    }
}
