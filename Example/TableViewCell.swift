//
//  TableViewCell.swift
//  rgb565
//
//  Created by Emil Wojtaszek on 23/03/2018.
//  Copyright © 2018 AppUnite.com. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    let randomTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 5
        label.clipsToBounds = true
        return label
    }()

    let randomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .light))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // add subviews
        self.contentView.addSubview(randomTextLabel)
        self.contentView.addSubview(randomImageView)
        self.contentView.addSubview(blurView)
        blurView.isHidden = true

        // add constraints
        applyConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// MARK: Private

    private func applyConstraints() {
        // horizontal constraints
        contentView.addConstraints(NSLayoutConstraint
            .constraints(withVisualFormat: "H:|-[imageView(120)]-[label]-|",
                         metrics: nil,
                         views: ["imageView": randomImageView, "label": randomTextLabel]))
        contentView.addConstraints(NSLayoutConstraint
            .constraints(withVisualFormat: "H:|-[blurView(120)]",
                         metrics: nil,
                         views: ["blurView": blurView]))

        // vertical constraints
        contentView.addConstraints(NSLayoutConstraint
            .constraints(withVisualFormat: "V:|-[imageView(120)]-|",
                         metrics: nil,
                         views: ["imageView": randomImageView]))
        contentView.addConstraints(NSLayoutConstraint
            .constraints(withVisualFormat: "V:|-[label]-|",
                         metrics: nil,
                         views: ["label": randomTextLabel]))
        contentView.addConstraints(NSLayoutConstraint
            .constraints(withVisualFormat: "V:|-[blurView(120)]",
                         metrics: nil,
                         views: ["blurView": blurView]))
    }
}
