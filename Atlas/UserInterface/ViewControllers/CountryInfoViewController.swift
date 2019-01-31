//
//  CountryInfoViewController.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class CountryInfoViewController: UITableViewController {

    let cellIdentifiers = ["CountryInfoTableViewCell", "CountryTableViewCell"]
    
    var country : Country!
    var countries: [Country]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var isInitialized = false
    
    static func makeCountryInfoVC(country: Country) -> CountryInfoViewController {
        let controller = CountryInfoViewController.init(style: .plain)
        controller.country = country
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = country.name
        
        for cellIdentifier in cellIdentifiers {
            self.tableView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        self.tableView.estimatedRowHeight = 60.0

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isInitialized {
            isInitialized = true
            
            ResourcesManager.shared.bordersCountries(country) { (countries) in
                if countries != nil {
                    self.countries = countries
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
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_tab2"), style: .plain, target: self, action: #selector(addToFavorites))
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard countries != nil else { return 1 }
        return 2
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        guard countries != nil else { return 0 }
        return countries!.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[indexPath.section], for: indexPath) as! CountryInfoTableViewCell
            
            cell.updateForCountry(country, countries)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[indexPath.section], for: indexPath) as! CountryTableViewCell
            
            cell.updateForCountry(countries![indexPath.row])
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == 1) {
            RouteManager.shared.showCountryInfoScreen(countries![indexPath.row])
        }
    }

}
