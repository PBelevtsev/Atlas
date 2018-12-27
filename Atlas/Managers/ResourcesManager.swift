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
    
    var flagsData = [[String : String]]()
    var regions = [[String : Any]]()
    var countries = [String : Any]()
    
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
            if let code = country["alpha2Code"] as? String {
                self.countries[code] = country
            }
        }
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
    
}
