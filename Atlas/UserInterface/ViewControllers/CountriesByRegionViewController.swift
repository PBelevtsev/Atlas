//
//  CountriesByRegionViewController.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit
import SVProgressHUD

class CountriesByRegionViewController: UITableViewController {

    let cellIdentifier = "CountryTableViewCell"
    
    var region : Region!
    var countries: [Country]!
    
    static func makeCountriesByRegionsVC(region: Region, countries: [Country]) -> CountriesByRegionViewController {
        
        let controller = CountriesByRegionViewController.init(style: .plain)
        controller.region = region
        controller.countries = countries
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = region.title
        self.tableView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.estimatedRowHeight = 60.0

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CountryTableViewCell

        cell.updateForCountry(countries![indexPath.row])
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RouteManager.shared.showCountryInfoScreen(countries![indexPath.row])
    }

}
