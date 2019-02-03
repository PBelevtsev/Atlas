//
//  CountryManager.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 2/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation

class CountryManager {
    
    func searchByRegion(_ region : Region!, _ completionHandler: @escaping (_ contries: [Country]?, _ error: Error?) -> ()) {
        
        RequestManager.shared.searchByRegion(region.isRegion ? "region" : "regionalbloc", region.key) { (countries, error) in
            ResourcesManager.shared.addToCache(countries)
            completionHandler(countries, error)
        }
        
    }
    
    func searchByName(_ name : String!, _ completionHandler: @escaping (_ contries: [Country]?, _ error: Error?) -> ()) {
        RequestManager.shared.searchByName(name) { (countries, error) in
            ResourcesManager.shared.addToCache(countries)
            completionHandler(countries, error)
        }
    }
    
    func bordersCountries(_ country : Country!, _ completionHandler: @escaping (_ contries: [Country]?) -> ()) {
        
        if country.borders.count > 0 {
            ResourcesManager.shared.countriesByCodes(country.borders, completionHandler)
        } else {
            completionHandler(nil)
        }
    }
    
}
