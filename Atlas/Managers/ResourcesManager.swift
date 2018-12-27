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
    
    var flagsData = [[String : String]]()
    var regions = [[String : Any]]()
    var countries = [String : Any]()
    var favorites = [String]()
    
    override init() {
        super.init()
        
        loadData()
    }
    
    func loadData() {
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String : String]] {
                    flagsData = jsonResult
                }
            } catch {
                
            }
        }
        
        if let path = Bundle.main.path(forResource: "regions", ofType: "plist") {
            regions = NSArray(contentsOfFile: path) as! [[String : Any]]
        }
        
        if let data = UserDefaults.standard.object(forKey: ResourcesManager.favoritesKey) as? String {
            let array = data.components(separatedBy: ";")
            favorites.append(contentsOf: array)
        }
    }
    
    func flagByCode(_ code : String!) -> String {
        for flag in flagsData {
            if let flagCode = flag["code"],
                let emoji = flag["emoji"] {
                if flagCode == code {
                    return emoji
                }
            }
        }
        return ""
    }
    
    func addToCache(_ countries: [[String : Any]]?) {
        guard countries != nil else { return }
        
        for country in countries! {
            if let code = country["alpha3Code"] as? String {
                self.countries[code] = country
            }
        }
    }
    
    func cacheCountries(_ codes: [String]!) -> [[String : Any]] {
        var countries = [[String : Any]]()
        
        for code in codes {
            if let country = self.countries[code] as? [String : Any] {
                countries.append(country)
            }
        }
        
        return countries
    }
    
    func searchByRegion(_ regionData : [String : Any]!, _ completionHandler: @escaping (_ contries: [[String : Any]]?, _ error: Error?) -> ()) {
        
        if let region = regionData["key"] as? String,
            let isRegion = regionData["is_region"] as? Bool {
            
            RequestManager.shared.searchByRegion(isRegion ? "region" : "regionalbloc", region) { (countries, error) in
                self.addToCache(countries)
                completionHandler(countries, error)
            }
            
        } else {
            completionHandler(nil, nil)
        }
    }
    
    func searchByName(_ name : String!, _ completionHandler: @escaping (_ contries: [[String : Any]]?, _ error: Error?) -> ()) {
        RequestManager.shared.searchByName(name) { (countries, error) in
            self.addToCache(countries)
            completionHandler(countries, error)
        }
    }
    
    func bordersCountries(_ country : [String : Any]!, _ completionHandler: @escaping (_ contries: [[String : Any]]?) -> ()) {
        
        if let borders = country["borders"] as? [String],
            borders.count > 0 {
            self.countriesByCodes(borders, completionHandler)
        } else {
            completionHandler(nil)
        }
    }
    
    func favoriteCountries(_ completionHandler: @escaping (_ contries: [[String : Any]]?) -> ()) {
        
        if favorites.count > 0 {
            countriesByCodes(favorites, completionHandler)
        } else {
            completionHandler(nil)
        }
    }
    
    func countriesByCodes(_ list : [String]!, _ completionHandler: @escaping (_ contries: [[String : Any]]?) -> ()) {
        
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

    func isFavorite(_ country : [String : Any]!) -> Bool {
        if let code = country["alpha3Code"] as? String {
            return favorites.contains(code)
        }
        return false
    }
    
    func addToFavorites(_ country : [String : Any]!) {
        if let code = country["alpha3Code"] as? String {
            favorites.append(code)
            saveFavorites()
        }
    }
    
    func removeFromFavorites(_ country : [String : Any]!) {
        if let code = country["alpha3Code"] as? String {
            favorites.removeAll { $0 == code }
            saveFavorites()
        }
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
