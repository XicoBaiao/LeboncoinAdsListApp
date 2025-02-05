//
//  LeboncoinListOfAdsAppUITests.swift
//  LeboncoinListOfAdsAppUITests
//
//  Created by Francisco Baião on 05/02/2025.
//

import XCTest

final class LeboncoinListOfAdsAppUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testCategoriesListIsDisplayed() {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 5), "Categories list did not load")
    }

    func testTapOnAdOpensDetailScreen() {
        // Find the ads collection view first
        let adsCollectionView = app.collectionViews.element(boundBy: 1)

        let firstAd = adsCollectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstAd.waitForExistence(timeout: 5), "First ad not found")

        firstAd.tap()

        let detailTitle = app.staticTexts["Description"]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 5), "Detail screen did not open")
    }


    func testCategoryFilter() {
        let categoryCollectionView = app.collectionViews.element(boundBy: 0)
        XCTAssertTrue(categoryCollectionView.waitForExistence(timeout: 5), "Category collection view not found")

        let firstCategory = categoryCollectionView.cells.element(boundBy: 1)
        XCTAssertTrue(firstCategory.exists, "First category does not exist")
        firstCategory.tap()

        // Check if ads list updated
        let adCollectionView = app.collectionViews.element(boundBy: 1)
        XCTAssertTrue(adCollectionView.waitForExistence(timeout: 5), "Ads list did not update after selecting category")
    }
}
