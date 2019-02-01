//
//  SearchCountryViewController.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class SearchCountryViewController: UIViewController {

    var dataSource : CountriesDataSource?
    
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var searchBar: SearchBar!
    
    var searchInProgress = false
    var searchName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = CountriesDataSource(tableViewData: tableViewData, useNativeName: false)
        
        searchBar.throttlingInterval = 0.5
     
        searchBar.onSearch = { text in
            self.searchCountry(text)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    // MARK: - Search
    
    func searchCountry(_ name : String!) {
        searchName = name
        if searchInProgress {
            return
        }
        
        if name.count == 0 {
            dataSource!.countries = nil
        } else {
            searchInProgress = true
            ResourcesManager.shared.searchByName(name) { (countries, error) in
                self.dataSource!.countries = countries
                
                self.searchInProgress = false
                
                if (name != self.searchName) {
                    self.searchCountry(self.searchName)
                }
            }
        }
        
    }

}
