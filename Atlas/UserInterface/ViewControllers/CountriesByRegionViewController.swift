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

    var dataSource : CountriesDataSource?
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
        dataSource = CountriesDataSource(tableViewData: self.tableView, useNativeName: true)
        dataSource!.countries = self.countries
        
    }

}
