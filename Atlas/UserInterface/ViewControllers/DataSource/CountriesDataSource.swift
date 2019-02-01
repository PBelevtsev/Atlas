//
//  CountriesDataSource.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 2/1/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation
import UIKit

class CountriesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifiers = ["CountryInfoTableViewCell", "CountryTableViewCell"]
    
    weak var tableViewData: UITableView!
    let useNativeName : Bool!
    var useEditMode = false
    
    var country : Country? {
        didSet {
            updateTableView()
        }
    }
    var countries: [Country]? {
        didSet {
            updateTableView()
        }
    }
    
    init(tableViewData: UITableView, useNativeName: Bool) {
        self.tableViewData = tableViewData
        self.useNativeName = useNativeName
        
        for cellIdentifier in cellIdentifiers {
            self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        self.tableViewData.estimatedRowHeight = 60.0
    }
    
    func updateTableView() {
        tableViewData.dataSource = self;
        tableViewData.delegate = self;
        tableViewData.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            guard country != nil else { return 0 }
            return 1
        } else {
            guard countries != nil else { return 0 }
            return countries!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[indexPath.section], for: indexPath) as! CountryInfoTableViewCell
            
            cell.updateForCountry(country, countries)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[indexPath.section], for: indexPath) as! CountryTableViewCell
            
            cell.updateForCountry(countries![indexPath.row], useNativeName)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == 1) {
            RouteManager.shared.showCountryInfoScreen(countries![indexPath.row])
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return useEditMode
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if useEditMode && (indexPath.section == 1) {
            if editingStyle == .delete {
                ResourcesManager.shared.removeFromFavorites(countries![indexPath.row])
                countries?.remove(at: indexPath.row)
            }
        }
    }
    
}
