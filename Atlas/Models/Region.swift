//
//  Region.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 2/1/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation

struct Region: Codable {
    var title: String
    var key: String
    var isRegion: Bool
    
    //Custom Keys
    enum CodingKeys: String, CodingKey {
        case title
        case key
        case isRegion = "is_region"
    }
    
}
