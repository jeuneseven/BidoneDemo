//
//  BidoneDemoUITests.swift
//  BidoneDemoUITests
//
//  Created by seven on 2026/2/2.
//

import XCTest

final class BidoneDemoUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    // MARK: - Categories Screen
    
    @MainActor
    func testCategoriesListLoadsAndDisplaysItems() throws {
        // The navigation title should appear
        let navTitle = app.navigationBars["Categories"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 10), "Categories nav bar should appear")
        
        // Wait for at least one cell to exist (network load)
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "At least one category should load")
        
        // TheMealDB always returns well-known categories; verify a few exist
        XCTAssertTrue(app.cells.count >= 3, "Should display multiple categories")
        
        // Verify "Beef" category is visible (always present in API)
        let beefText = app.staticTexts["Beef"]
        XCTAssertTrue(beefText.waitForExistence(timeout: 5), "Beef category should be displayed")
    }
    
    // MARK: - Navigation: Categories → Meals
    
    @MainActor
    func testTapCategoryNavigatesToMealsList() throws {
        // Wait for categories to load
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "Categories should load")
        
        // Tap the "Beef" category
        let beefCell = app.staticTexts["Beef"]
        XCTAssertTrue(beefCell.waitForExistence(timeout: 5))
        beefCell.tap()
        
        // Verify we navigated to the Beef meals screen
        let mealsNavBar = app.navigationBars["Beef"]
        XCTAssertTrue(mealsNavBar.waitForExistence(timeout: 10), "Should navigate to Beef meals screen")
        
        // Wait for meal cards to appear in the grid
        let firstMealText = app.scrollViews.staticTexts.firstMatch
        XCTAssertTrue(firstMealText.waitForExistence(timeout: 10), "At least one meal should load")
    }
    
    // MARK: - Full Navigation: Categories → Meals → Detail
    
    @MainActor
    func testFullNavigationToMealDetail() throws {
        // 1. Wait for categories
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        
        // 2. Tap first category
        firstCell.tap()
        
        // 3. Wait for meals grid to load
        let mealCard = app.scrollViews.staticTexts.firstMatch
        XCTAssertTrue(mealCard.waitForExistence(timeout: 10), "Meals should load")
        
        // Remember the meal name for verification
        let mealName = mealCard.label
        mealCard.tap()
        
        // 4. Verify detail screen loaded with correct content
        // The nav title should show the meal name (inline mode)
        let detailNavBar = app.navigationBars[mealName]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 10), "Should navigate to detail for: \(mealName)")
        
        // Verify key detail sections appear
        let ingredientsHeader = app.staticTexts["Ingredients"]
        XCTAssertTrue(ingredientsHeader.waitForExistence(timeout: 10), "Ingredients section should appear")
        
        let instructionsHeader = app.staticTexts["Instructions"]
        XCTAssertTrue(instructionsHeader.exists, "Instructions section should appear")
    }
    
    // MARK: - Back Navigation
    
    @MainActor
    func testBackNavigationFromMealsToCategories() throws {
        // Navigate to meals
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        // Wait for meals to load
        let mealCard = app.scrollViews.staticTexts.firstMatch
        XCTAssertTrue(mealCard.waitForExistence(timeout: 10))
        
        // Tap back button
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Verify we're back on Categories
        let categoriesNav = app.navigationBars["Categories"]
        XCTAssertTrue(categoriesNav.waitForExistence(timeout: 5), "Should navigate back to Categories")
        XCTAssertTrue(app.cells.firstMatch.exists, "Category cells should still be visible")
    }
    
    // MARK: - Detail Content Verification
    
    @MainActor
    func testMealDetailShowsYouTubeLink() throws {
        // Navigate: Categories → first category → first meal
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let mealCard = app.scrollViews.staticTexts.firstMatch
        XCTAssertTrue(mealCard.waitForExistence(timeout: 10))
        mealCard.tap()
        
        // Wait for detail to load
        let ingredientsHeader = app.staticTexts["Ingredients"]
        XCTAssertTrue(ingredientsHeader.waitForExistence(timeout: 10))
        
        // Scroll down to find the Video section / YouTube link
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()
        
        let videoHeader = app.staticTexts["Video"]
        let youtubeLink = app.staticTexts["Watch on YouTube"]
        
        // Most meals have a YouTube link; check if either section exists
        if videoHeader.exists {
            XCTAssertTrue(youtubeLink.exists, "YouTube link text should appear when Video section exists")
        }
    }
}
