//
//  AtlasTests.swift
//  AtlasTests
//
//  Created by Pavel Belevtsev on 2/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import XCTest
@testable import Atlas

class AtlasRegionsTests: XCTestCase {
    var regionsVC : RegionsViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: RegionsViewController = storyboard.instantiateViewController(withIdentifier: "RegionsViewController") as! RegionsViewController
        let _ = vc.view
        regionsVC = vc
    }
    
    override func tearDown() {
        regionsVC = nil
    }
    
    func testRegionsScreen() {
        XCTAssertEqual(regionsVC.regions.count, 18, "Check Regions list after loading")
        
        let firstCell = regionsVC.tableView(regionsVC.tableViewData, cellForRowAt: IndexPath.init(row: 0, section: 0))
        XCTAssert(firstCell.textLabel?.text == "Africa");
        let secondCell = regionsVC.tableView(regionsVC.tableViewData, cellForRowAt: IndexPath.init(row: 1, section: 0))
        XCTAssert(secondCell.textLabel?.text == "Americas");
    }
    
}

class AtlasSearchTests: XCTestCase {
    var searchVC : SearchCountryViewController!
    
    override func setUp() {
        ConfigManager.shared.testMode = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: SearchCountryViewController = storyboard.instantiateViewController(withIdentifier: "SearchCountryViewController") as! SearchCountryViewController
        let _ = vc.view
        searchVC = vc
    }
    
    override func tearDown() {
        searchVC = nil
    }
    
    func testSearch() {
        searchVC.searchBar.text = "Ukr"
        XCTAssert(searchVC.searchTextIsCorrectSize(), "Search text has correct size")
        searchVC.searchProcess() { (countries, error) in
            XCTAssertEqual(countries?.count, 1, "Check Search list results count")
        }
    }
    
}

class AtlasCountriesByRegionTests: XCTestCase {
    var countriesVC : CountriesByRegionViewController!
    
    override func setUp() {
        let countryManager = FakeCountryManager()
        countryManager.countriesFromJson("nafta") { (countries) in
            let vc: CountriesByRegionViewController = CountriesByRegionViewController.makeCountriesByRegionsVC(region: Region(title: "North American Free Trade Agreement", key: "nafta", isRegion: false), countries: countries!)
            let _ = vc.view
            self.countriesVC = vc
        }
    }
    
    override func tearDown() {
        countriesVC = nil
    }
    
    func testCountriesByRegion() {
        XCTAssertEqual(countriesVC.countries.count, 3, "Check NAFTA countries list count")
        
        let firstCell = countriesVC.dataSource!.tableView(countriesVC.tableView, cellForRowAt: IndexPath.init(row: 0, section: 1)) as! CountryTableViewCell
        XCTAssert(firstCell.labelName.text == "Canada");
    }
    
}

class AtlasCountryInfoFavoritesTests: XCTestCase {
    var countryInfoVC : CountryInfoViewController!
    var favoritesVC : FavoritesViewController!
    
    override func setUp() {
        ResourcesManager.shared.clearFavorites()
        ConfigManager.shared.testMode = true
        let countryManager = FakeCountryManager()
        countryManager.countriesFromJson("search") { (countries) in
            let vc: CountryInfoViewController = CountryInfoViewController.makeCountryInfoVC(country: countries![0])
            let _ = vc.view
            self.countryInfoVC = vc
            
            self.countryInfoVC.beginAppearanceTransition(true, animated: false)
            self.countryInfoVC.endAppearanceTransition()
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: FavoritesViewController = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        let _ = vc.view
        favoritesVC = vc
        
    }
    
    override func tearDown() {
        countryInfoVC = nil
        favoritesVC = nil
    }
    
    func testCountryInfoFavorites() {
        let exp = expectation(description: "Test after 1 second")
        _ = XCTWaiter.wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(countryInfoVC.borderCountriesCount(), 7, "Check borders countries list count")
        
        let firstCell = countryInfoVC.dataSource!.tableView(countryInfoVC.tableView, cellForRowAt: IndexPath.init(row: 0, section: 1)) as! CountryTableViewCell
        XCTAssert(firstCell.labelName.text == "Belarus");
        
        countryInfoVC.addToFavorites()
        
        favoritesVC.beginAppearanceTransition(true, animated: false)
        favoritesVC.endAppearanceTransition()
        
        let expFav = expectation(description: "Test after 1 second")
        _ = XCTWaiter.wait(for: [expFav], timeout: 1)
        
        XCTAssertEqual(favoritesVC.favoritesCountriesCount(), 1, "Check favorites countries list count")
    }
    
}

