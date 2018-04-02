//
//  Model.swift
//  rgb565
//
//  Created by Emil Wojtaszek on 29/03/2018.
//  Copyright © 2018 AppUnite.com. All rights reserved.
//

import Foundation

struct Model {
    let title: String
    let imageURL: URL
    let placeholder: Data
}

extension Model: Decodable {
    enum MyStructKeys: String, CodingKey {
        case title
        case imageURL
        case placeholder
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self)
        let title: String = try container.decode(String.self, forKey: .title)
        let imageURL: URL = try container.decode(URL.self, forKey: .imageURL)
        let placeholder: String = try container.decode(String.self, forKey: .placeholder)
        let data = Data(base64Encoded: placeholder)!

        //
        self.init(title: title, imageURL: imageURL, placeholder: data)
    }
}
