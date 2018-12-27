//
//  SearchCountryViewController.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class SearchCountryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellIdentifier = "CountryTableViewCell"
    
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var searchBar: SearchBar!
    
    var searchInProgress = false
    var searchName = ""
    
    var countries: [[String : Any]]? {
        didSet {
            tableViewData.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableViewData.estimatedRowHeight = 60.0

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
            self.countries = nil
        } else {
            searchInProgress = true
            ResourcesManager.shared.searchByName(name) { (countries, error) in
                self.countries = countries
                self.searchInProgress = false
                
                if (name != self.searchName) {
                    self.searchCountry(self.searchName)
                }
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard countries != nil else { return 0 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard countries != nil else { return 0 }
        return countries!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CountryTableViewCell
        
        cell.updateForCountry(countries![indexPath.row], false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        RouteManager.shared.showCountryInfoScreen(countries![indexPath.row])
    }

}
