//
//  SnapshotTests.swift
//  BidoneDemoUITests
//
//  Created by seven on 2026/2/4.
//

import XCTest

@MainActor
final class SnapshotTests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    // MARK: - Screenshots
    
    @MainActor
    func testScreenshots() throws {
        // 1. Categories screen
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 15), "Categories should load")
        snapshot("01_Categories")
        
        // 2. Tap into a category → Meals screen
        firstCell.tap()
        let mealCard = app.scrollViews.staticTexts.firstMatch
        XCTAssertTrue(mealCard.waitForExistence(timeout: 15), "Meals should load")
        snapshot("02_Meals")
        
        // 3. Tap a meal → Detail screen
        let mealName = mealCard.label
        mealCard.tap()
        let detailNavBar = app.navigationBars[mealName]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 15), "Detail should load")
        snapshot("03_MealDetail_Top")
        
        // 4. Scroll down to show ingredients & instructions
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()
        snapshot("04_MealDetail_Bottom")
    }
}
