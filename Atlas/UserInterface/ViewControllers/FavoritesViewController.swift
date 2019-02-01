//
//  FavoritesViewController.swift
//  Atlas
//
//  Created by Pavel Belevtsev on 12/27/18.
//  Copyright © 2018 Pavel Belevtsev. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    var dataSource : CountriesDataSource?
    
    @IBOutlet weak var barButtonEdit: UIBarButtonItem!
    @IBOutlet weak var tableViewData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = CountriesDataSource(tableViewData: tableViewData, useNativeName: true)
        dataSource!.useEditMode = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ResourcesManager.shared.favoriteCountries({ (countries) in
            self.dataSource!.countries = countries
            self.updateBarButtonEdit()
        })
        
    }
    
    // MARK: - Actions
    
    @IBAction func barButtonEditPressed(_ sender: UIBarButtonItem) {
        
        tableViewData.isEditing = !tableViewData.isEditing
        updateBarButtonEdit()
        
    }
    
    func updateBarButtonEdit() {
        
        barButtonEdit.isEnabled = (dataSource!.countries != nil) && (dataSource!.countries!.count > 0)
        barButtonEdit.title = (tableViewData.isEditing && barButtonEdit.isEnabled) ? "Done" : "Edit"
        
    }
    
}
