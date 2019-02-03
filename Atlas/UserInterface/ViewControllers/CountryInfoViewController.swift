//
//  CountryInfoViewController.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class CountryInfoViewController: UITableViewController {

    var countryManager = CountryManager()
    var dataSource : CountriesDataSource?
    
    var country : Country!

    var isInitialized = false
    
    static func makeCountryInfoVC(country: Country) -> CountryInfoViewController {
        let controller = CountryInfoViewController.init(style: .plain)
        controller.country = country
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = country.name
        dataSource = CountriesDataSource(tableViewData: self.tableView, useNativeName: true)
        dataSource!.country = country
        
        self.tableView.accessibilityLabel = "tableViewCountryInfo"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isInitialized {
            isInitialized = true
            
            countryManager.bordersCountries(country) { (countries) in
                if countries != nil {
                    self.dataSource!.countries = countries
                }
            }
        }
        
        updateFavoriteButton()
        
    }
    
    // MARK: - Favorites
    
    @objc func addToFavorites(sender: UIBarButtonItem!) {
        ResourcesManager.shared.addToFavorites(country)
        updateFavoriteButton()
    }
    
    @objc func removeFromFavorites(sender: UIBarButtonItem!) {
        ResourcesManager.shared.removeFromFavorites(country)
        updateFavoriteButton()
    }
    
    func updateFavoriteButton() {
        if ResourcesManager.shared.isFavorite(country) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_tab2_selected"), style: .plain, target: self, action: #selector(removeFromFavorites))
            self.navigationItem.rightBarButtonItem?.accessibilityLabel = "removeFromFavoritesButton"
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_tab2"), style: .plain, target: self, action: #selector(addToFavorites))
            self.navigationItem.rightBarButtonItem?.accessibilityLabel = "addToFavoritesButton"
        }
    }

    
    func borderCountriesCount() -> Int {
        return self.dataSource!.countries?.count ?? 0
    }
    
}
