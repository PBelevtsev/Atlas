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
            self.tableViewData.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        searchBar.throttlingInterval = 0.5
     
        searchBar.onSearch = { text in
            self.searchCountry(text)
        }
        
    }
    
    // MARK: - Search
    
    func searchCountry(_ name : String!) {
        self.searchName = name
        if self.searchInProgress {
            return
        }
        
        if name.count == 0 {
            self.countries = nil
        } else {
            self.searchInProgress = true
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
        
        guard self.countries != nil else { return 0 }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard self.countries != nil else { return 0 }
        return self.countries!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CountryTableViewCell
        
        cell.updateForCountry(self.countries![indexPath.row], false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        RouteManager.shared.showCountryInfoScreen(self.countries![indexPath.row])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
