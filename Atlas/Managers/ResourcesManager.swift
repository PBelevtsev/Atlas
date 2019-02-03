//
//  ResourcesManager.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/26/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class ResourcesManager: NSObject {

    static let shared = ResourcesManager()
    static let favoritesKey = "favoritesKey"
    
    var flags = [Flag]()
    var regions = [Region]()
    var countries = [String : Country]()
    var favorites = [String]()
    
    override init() {
        super.init()
        
        loadData(flagsData: "data.json", regionsData: "regions.plist")
    }
    
    func loadData(flagsData fileNameFlags : String, regionsData fileNameRegions : String) {
        
        fillFlagsData(fileNameFlags)
        fillRegionsData(fileNameRegions)
        fillFavorites()
        
    }
    
    func fillFlagsData(_ fileName : String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "") {
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                flags = try decoder.decode([Flag].self, from:data)
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        }
    }
    
    func fillRegionsData(_ fileName : String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = PropertyListDecoder()
                regions = try decoder.decode([Region].self, from:data)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    
    func fillFavorites() {
        if let data = UserDefaults.standard.object(forKey: ResourcesManager.favoritesKey) as? String {
            let array = data.components(separatedBy: ";")
            favorites.append(contentsOf: array)
        }
    }
    
    func flagByCode(_ code : String!) -> String {
        if let flag = flags.first(where: {$0.code == code}) {
            return flag.emoji
        } else {
            return ""
        }
    }
    
    func addToCache(_ countries: [Country]?) {
        guard countries != nil else { return }
        
        for country in countries! {
            self.countries[country.alpha3] = country
        }
    }
    
    func cacheCountries(_ codes: [String]!) -> [Country] {
        var countries = [Country]()
        
        for code in codes {
            if let country = self.countries[code] {
                countries.append(country)
            }
        }
        
        return countries
    }
    
    func favoriteCountries(_ completionHandler: @escaping (_ contries: [Country]?) -> ()) {
        
        if favorites.count > 0 {
            countriesByCodes(favorites, completionHandler)
        } else {
            completionHandler(nil)
        }
    }
    
    func countriesByCodes(_ list : [String]!, _ completionHandler: @escaping (_ contries: [Country]?) -> ()) {
        
        var codes = [String]()
        for code in list {
            if countries[code] == nil {
                codes.append(code)
            }
        }
        if codes.count > 0 {
            RequestManager.shared.searchByCodes(codes) { (countries, error) in
                self.addToCache(countries)
                completionHandler(self.cacheCountries(list))
            }
        } else {
            completionHandler(self.cacheCountries(list))
        }
    }

    func isFavorite(_ country : Country!) -> Bool {
        return favorites.contains(country.alpha3)
    }
    
    func addToFavorites(_ country : Country!) {
        favorites.append(country.alpha3)
        saveFavorites()
    }
    
    func removeFromFavorites(_ country : Country!) {
        favorites.removeAll { $0 == country.alpha3 }
        saveFavorites()
    }
    
    func saveFavorites() {
        if favorites.count > 0 {
            favorites = favorites.sorted(by: <)
            let data = favorites.joined(separator: ";")
            UserDefaults.standard.set(data, forKey: ResourcesManager.favoritesKey)
        } else {
            UserDefaults.standard.removeObject(forKey: ResourcesManager.favoritesKey)
        }
        UserDefaults.standard.synchronize()
    }
    
}
