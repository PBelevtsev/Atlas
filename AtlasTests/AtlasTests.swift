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
    
    func testRegionsCount() {
        XCTAssertEqual(regionsVC.regions.count, 18, "Check Regions list after loading")
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
    
    func testSearchText() {
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
    
    func testCountriesByRegionText() {
        XCTAssertEqual(countriesVC.countries.count, 3, "Check NAFTA countries list count")
    }
    
}

class AtlasCountryInfoTests: XCTestCase {
    var countryInfoVC : CountryInfoViewController!
    
    override func setUp() {
        ConfigManager.shared.testMode = true
        let countryManager = FakeCountryManager()
        countryManager.countriesFromJson("search") { (countries) in
            let vc: CountryInfoViewController = CountryInfoViewController.makeCountryInfoVC(country: countries![0])
            let _ = vc.view
            self.countryInfoVC = vc
            
            self.countryInfoVC.beginAppearanceTransition(true, animated: false)
            self.countryInfoVC.endAppearanceTransition()
        }
    }
    
    override func tearDown() {
        countryInfoVC = nil
    }
    
    func testCountriesByRegionText() {
        let exp = expectation(description: "Test after 1 second")
        _ = XCTWaiter.wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(countryInfoVC.borderCountriesCount(), 7, "Check borders countries list count")
    }
    
}

