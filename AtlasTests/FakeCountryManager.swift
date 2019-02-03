//
//  FakeCountryManager.swift
//  AtlasTests
//
//  Created by Pavel Belevtsev on 2/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation
@testable import Atlas

class FakeCountryManager: CountryManager {
    
    func countriesFromJson(_ fileName : String!, _ completionHandler: @escaping (_ contries: [Country]?) -> ()) {
        
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                RequestManager.shared.parsingCountries(data) { (countries, error) in
                    completionHandler(countries)
                }
            } catch {
                
            }
        }
        
    }
    
    override func searchByName(_ name : String!, _ completionHandler: @escaping (_ contries: [Country]?, _ error: Error?) -> ()) {
        
        countriesFromJson("search") { (countries) in
            ResourcesManager.shared.addToCache(countries)
            completionHandler(countries, nil)
        }
    
    }
    
    override func bordersCountries(_ country : Country!, _ completionHandler: @escaping (_ contries: [Country]?) -> ()) {
        
        countriesFromJson("borders") { (countries) in
            ResourcesManager.shared.addToCache(countries)
            completionHandler(countries)
        }
        
    }
    
}
