//
//  RouteManager.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class RouteManager: NSObject {
    
    static let shared = RouteManager()
    
    func mainNavigationController() -> UINavigationController {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window!.rootViewController as! UINavigationController
    }
    
    func showCountriesByRegionScreen(_ regionData : [String : Any]!, _ countries : [[String : Any]]!) {
        let controller = CountriesByRegionViewController.makeCountriesByRegionsVC(regionData: regionData, countries: countries);
        self.mainNavigationController().pushViewController(controller, animated: true)
    }
    
    func showCountryInfoScreen(_ country : [String : Any]!) {
        let controller = CountryInfoTableViewController.makeCountryInfoVC(country: country);
        self.mainNavigationController().pushViewController(controller, animated: true)
    }
    
}
