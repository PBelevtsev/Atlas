//
//  RegionsViewController.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/26/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let countryManager = CountryManager()
    
    @IBOutlet weak var tableViewData: UITableView!
    var regions = [Region]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData.estimatedRowHeight = 44.0
        initData()
        
    }

    func initData() {
        regions = ResourcesManager.shared.regions;
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath)

        let region = regions[indexPath.row];
        cell.textLabel?.text = region.title
        cell.textLabel?.numberOfLines = 2;
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let region = regions[indexPath.row];
        
        SVProgressHUD.show()
        countryManager.searchByRegion(region) { (countries, error) in
            SVProgressHUD.dismiss()
            if countries != nil {
                RouteManager.shared.showCountriesByRegionScreen(region, countries)
            }
        }
    }

}
