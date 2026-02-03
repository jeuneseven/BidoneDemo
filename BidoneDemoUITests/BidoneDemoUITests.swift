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
        app.launchArguments += ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()
    }
    
    // MARK: - Categories Screen
    
    @MainActor
    func testCategoriesListLoadsAndDisplaysItems() throws {
        let navTitle = app.navigationBars["Categories"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 10), "Categories nav bar should appear")
        
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "At least one category should load")
        
        XCTAssertTrue(app.cells.count >= 3, "Should display multiple categories")
        
        let beefText = app.staticTexts["Beef"]
        XCTAssertTrue(beefText.waitForExistence(timeout: 5), "Beef category should be displayed")
    }
    
    // MARK: - Navigation: Categories → Meals
    
    @MainActor
    func testTapCategoryNavigatesToMealsList() throws {
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "Categories should load")
        
        let beefCell = app.staticTexts["Beef"]
        XCTAssertTrue(beefCell.waitForExistence(timeout: 5))
        beefCell.tap()
        
        let mealsNavBar = app.navigationBars["Beef"]
        XCTAssertTrue(mealsNavBar.waitForExistence(timeout: 10), "Should navigate to Beef meals screen")
        
        let firstMealText = app.scrollViews.staticTexts.firstMatch
        XCTAssertTrue(firstMealText.waitForExistence(timeout: 10), "At least one meal should load")
    }
    
    // MARK: - Full Navigation: Categories → Meals → Detail
    
    @MainActor
    func testFullNavigationToMealDetail() throws {
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let mealCard = app.scrollViews.staticTexts.firstMatch
        XCTAssertTrue(mealCard.waitForExistence(timeout: 10), "Meals should load")
        
        let mealName = mealCard.label
        mealCard.tap()
        
        let detailNavBar = app.navigationBars[mealName]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 10), "Should navigate to detail for: \(mealName)")
        
        let ingredientsHeader = app.staticTexts["Ingredients"]
        XCTAssertTrue(ingredientsHeader.waitForExistence(timeout: 10), "Ingredients section should appear")
        
        let instructionsHeader = app.staticTexts["Instructions"]
        XCTAssertTrue(instructionsHeader.exists, "Instructions section should appear")
    }
    
    // MARK: - Back Navigation
    
    @MainActor
    func testBackNavigationFromMealsToCategories() throws {
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let mealCard = app.scrollViews.staticTexts.firstMatch
        XCTAssertTrue(mealCard.waitForExistence(timeout: 10))
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        let categoriesNav = app.navigationBars["Categories"]
        XCTAssertTrue(categoriesNav.waitForExistence(timeout: 5), "Should navigate back to Categories")
        XCTAssertTrue(app.cells.firstMatch.exists, "Category cells should still be visible")
    }
    
    // MARK: - Detail Content Verification
    
    @MainActor
    func testMealDetailShowsYouTubeLink() throws {
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        let mealCard = app.scrollViews.staticTexts.firstMatch
        XCTAssertTrue(mealCard.waitForExistence(timeout: 10))
        mealCard.tap()
        
        let ingredientsHeader = app.staticTexts["Ingredients"]
        XCTAssertTrue(ingredientsHeader.waitForExistence(timeout: 10))
        
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()
        
        let videoHeader = app.staticTexts["Video"]
        let youtubeLink = app.staticTexts["Watch on YouTube"]
        
        if videoHeader.exists {
            XCTAssertTrue(youtubeLink.exists, "YouTube link text should appear when Video section exists")
        }
    }
}
