//
//  PlaceholderView.swift
//  rgb565
//
//  Created by Emil Wojtaszek on 24/03/2018.
//  Copyright © 2018 AppUnite.com. All rights reserved.
//

import UIKit
import Kingfisher

class PlaceholderView: UIImageView, Placeholder {

    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.alpha = 0.9
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.addSubview(blurView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        //
        self.blurView.frame = self.bounds
    }
}
