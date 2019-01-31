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
    
    func showCountriesByRegionScreen(_ region : Region!, _ countries : [Country]!) {
        let controller = CountriesByRegionViewController.makeCountriesByRegionsVC(region: region, countries: countries);
        mainNavigationController().pushViewController(controller, animated: true)
    }
    
    func showCountryInfoScreen(_ country : Country!) {
        let controller = CountryInfoViewController.makeCountryInfoVC(country: country);
        mainNavigationController().pushViewController(controller, animated: true)
    }
    
}
