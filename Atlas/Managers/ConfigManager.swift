//
//  ConfigManager.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class ConfigManager: NSObject {
    
    static let shared = ConfigManager()
    
    static let remoteURL: String = "https://restcountries.eu/rest/v2/"
    static let testModeId: String = "UITestingMode"
    
    var testMode = false
    
    func countryManager() -> CountryManager {
        return self.testMode ? FakeCountryManager() : CountryManager()
    }
    
}
