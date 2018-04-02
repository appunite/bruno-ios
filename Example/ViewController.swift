//
//  ViewController.swift
//  Example
//
//  Created by Emil Wojtaszek on 03/04/2018.
//  Copyright © 2018 AppUnite.com. All rights reserved.
//

import UIKit
import Kingfisher
import Bruno

class TableViewController: UITableViewController {
    var models: [Model] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Clear memory cache right away.
        ImageCache.default.clearMemoryCache()

        // Clear disk cache. This is an async operation.
        ImageCache.default.clearDiskCache()

        // parse payload
        let payload = Bundle.main.path(forResource: "payload", ofType: "json")
            .flatMap { URL(fileURLWithPath: $0) }
            .flatMap { try? Data(contentsOf: $0, options: .mappedIfSafe) }
            .flatMap { try? JSONDecoder().decode([Model].self, from: $0) }

        //
        self.models = payload ?? []

        // register cell
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        // set placeholder
        let placeholderView = PlaceholderView(frame: .zero)
        placeholderView.image = model.placeholder.decodeRGB565(width: 8, height: 8)

        // update title
        cell.randomTextLabel.text = model.title
//        cell.randomImageView.kf.indicatorType = .activity

        // download image
        _ = cell.randomImageView.kf.setImage(with: model.imageURL,
                                             placeholder: placeholderView,
                                             options: [.transition(ImageTransition.fade(1))]
        )

        return cell
    }
}
