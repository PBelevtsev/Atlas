//
//  CountryData.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 2/1/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation

struct CountryData: Codable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
    
}
