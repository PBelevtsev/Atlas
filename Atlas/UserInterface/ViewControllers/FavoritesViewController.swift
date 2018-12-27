//
//  FavoritesViewController.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellIdentifier = "CountryTableViewCell"
    
    @IBOutlet weak var barButtonEdit: UIBarButtonItem!
    @IBOutlet weak var tableViewData: UITableView!
    
    var countries: [[String : Any]]? {
        didSet {
            tableViewData.reloadData()
            updateBarButtonEdit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ResourcesManager.shared.favoriteCountries({ (countries) in
            self.countries = countries
        })
        
    }
    
    // MARK: - Actions
    
    @IBAction func barButtonEditPressed(_ sender: UIBarButtonItem) {
        
        tableViewData.isEditing = !tableViewData.isEditing
        updateBarButtonEdit()
        
    }
    
    func updateBarButtonEdit() {
        
        barButtonEdit.isEnabled = (countries != nil) && (countries!.count > 0)
        barButtonEdit.title = (tableViewData.isEditing && barButtonEdit.isEnabled) ? "Done" : "Edit"
        
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
        
        cell.updateForCountry(countries![indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        RouteManager.shared.showCountryInfoScreen(countries![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ResourcesManager.shared.removeFromFavorites(countries![indexPath.row])
            countries?.remove(at: indexPath.row)
        }
    }
    
}
