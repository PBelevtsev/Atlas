//
//  AtlasUITests.swift
//  AtlasUITests
//
//  Created by Pavel Belevtsev on 2/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import XCTest

class AtlasUITests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments.append("UITestingMode")
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserFlow() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        // Scroll Regions list to last item
        let tableRegions = tablesQuery["tableViewRegions"]
        let lastCell = tableRegions.cells.element(boundBy: tableRegions.cells.count-1)
        tableRegions.scrollToElement(element: lastCell)
        
        let regionName = "North American Free Trade Agreement"
        // Open region - show countries list
        tablesQuery.staticTexts[regionName].tap()
        sleep(1)
        
        let regionTitleText = app.navigationBars.otherElements[regionName]
        XCTAssertTrue(regionTitleText.exists, "Incorrect Region title")
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
    
        // Select Search tab, search country
        app.tabBars.children(matching: .button).element(boundBy: 1).tap()
        let searchBar = app.otherElements["searchBarCountries"]
        searchBar.tap()
        sleep(1)
        searchBar.typeText("Ukr")
        sleep(1)
        
        // Open country info
        let tableSearchResults = tablesQuery["tableViewSearchResults"]
        tableSearchResults.cells.element(boundBy: 0).tap()
        sleep(1)
        let ukraineTitleText = app.navigationBars.otherElements["Ukraine"]
        XCTAssertTrue(ukraineTitleText.exists, "Incorrect Search Result title")
        sleep(1)
        
        // Add country to favorites
        var addToFavoritesButton = app.navigationBars.buttons["addToFavoritesButton"]
        if addToFavoritesButton.exists {
            addToFavoritesButton.tap()
            sleep(1)
        }
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Select Favorites tab, turn on/off edit mode
        app.tabBars.children(matching: .button).element(boundBy: 2).tap()

        sleep(1)
        let favoritesTitleText = app.navigationBars.otherElements["Favorites"]
        XCTAssertTrue(favoritesTitleText.exists, "Incorrect Favorites title")
        
        app.navigationBars.buttons["editModeButton"].tap()
        sleep(1)
        app.navigationBars.buttons["editModeButton"].tap()
        
        // Open first favorite country
        let tableFavorites = tablesQuery["tableFavorites"]
        tableFavorites.cells.element(boundBy: 0).tap()
        sleep(2)
        
        // Open first border country and add to favorites
        let tableViewCountryInfo = tablesQuery["tableViewCountryInfo"]
        tableViewCountryInfo.cells.element(boundBy: 1).tap()
        sleep(1)
        
        let borderCountryTitleText = app.navigationBars.otherElements["Belarus"]
        XCTAssertTrue(borderCountryTitleText.exists, "Incorrect Border Country title")

        sleep(1)
        addToFavoritesButton = app.navigationBars.buttons["addToFavoritesButton"]
        if addToFavoritesButton.exists {
            addToFavoritesButton.tap()
            sleep(1)
        }
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Remove country from favorites from country info screen
        let removeFromFavoritesButton = app.navigationBars.buttons["removeFromFavoritesButton"]
        if removeFromFavoritesButton.exists {
            removeFromFavoritesButton.tap()
            sleep(1)
        }
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Remove country from favorites from favorites screen
        sleep(1)
        let firstFavoriteCell = tableFavorites.cells.element(boundBy: 0)
        firstFavoriteCell.swipeLeft()
        firstFavoriteCell.buttons["Delete"].tap()
        sleep(2)
        
        // Select Start screen
        app.tabBars.children(matching: .button).element(boundBy: 0).tap()
        sleep(2)
    }

}
