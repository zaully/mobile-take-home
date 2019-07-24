//
//  EpisodesViewController.swift
//  rickmorty
//
//  Created by Vince Liang on 2019-07-22.
//  Copyright © 2019 Vince. All rights reserved.
//

import UIKit

class EpisodesViewController: UITableViewController {

    private var vm: EpisodesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        vm = EpisodesViewModelImpl(service: Services.shared.episode)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.view = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.episodeCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? EpisodeCell {
            cell.config(with: vm.getEpisode(index: indexPath.row))
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension EpisodesViewController: EpisodesView {
    func handle(viewEvent: EpisodesViewEvent) {
        switch viewEvent {
        case .error(let error):
            show(error: error)
        case .insert(let itemCount, let startIndex):
            let items = (startIndex..<startIndex + itemCount).map { (i) -> IndexPath in
                return IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: items, with: .automatic)
        }
    }
}

extension EpisodesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths where index.row == vm.episodeCount - 1 {
            vm.loadMore()
        }
    }
}
