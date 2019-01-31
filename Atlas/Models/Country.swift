//
//  Country.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 2/1/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation

struct Country: Codable {
    var alpha2: String
    var alpha3: String
    var borders: [String]
    var name: String
    var nativeName: String
    var title: String
    var latlng: [Double]
    var currencies: [[String : String]]
    var languages: [[String : String]]
    
    //Custom Keys
    enum CodingKeys: String, CodingKey {
        case alpha2 = "alpha2Code"
        case alpha3 = "alpha3Code"
        case borders
        case name
        case nativeName
        case title
        case latlng
        case currencies
        case languages
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.alpha2 = try container.decodeIfPresent(String.self, forKey: .alpha2) ?? ""
        self.alpha3 = try container.decodeIfPresent(String.self, forKey: .alpha3) ?? ""
        self.borders = try container.decodeIfPresent([String].self, forKey: .borders) ?? []
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.nativeName = try container.decodeIfPresent(String.self, forKey: .nativeName) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.latlng = try container.decodeIfPresent([Double].self, forKey: .latlng) ?? []
        self.currencies = try container.decodeIfPresent([[String : String]].self, forKey: .currencies) ?? []
        self.languages = try container.decodeIfPresent([[String : String]].self, forKey: .languages) ?? []
    }
    
}

