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

    @IBOutlet weak var tableViewData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData.estimatedRowHeight = 44.0

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResourcesManager.shared.regions.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath)

        let region = ResourcesManager.shared.regions[indexPath.row];
        cell.textLabel?.text = region["title"] as? String
        cell.textLabel?.numberOfLines = 2;
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let region = ResourcesManager.shared.regions[indexPath.row];
        
        SVProgressHUD.show()
        ResourcesManager.shared.searchByRegion(region) { (countries, error) in
            SVProgressHUD.dismiss()
            if countries != nil {
                RouteManager.shared.showCountriesByRegionScreen(region, countries)
            }
        }
    }

}
