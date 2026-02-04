//
//  BidoneDemoUITests.swift
//  BidoneDemoUITests
//
//  Created by seven on 2026/2/2.
//

import XCTest

final class BidoneDemoUITests: XCTestCase {
    private var app: XCUIApplication!
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()
    }

    // MARK: - Helpers

    /// Wait for categories to load and return the first cell
    @MainActor
    private func waitForCategories() -> XCUIElement {
        let categoriesNav = app.navigationBars["Categories"]
        XCTAssertTrue(categoriesNav.waitForExistence(timeout: 15), "Categories nav bar should appear")

        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 15), "At least one category should load")
        return firstCell
    }

    /// Tap a category and wait for meals to load
    @MainActor
    private func navigateToMeals(tapping cell: XCUIElement) -> XCUIElement {
        cell.tap()

        // On iPad, meals appear in the content column alongside the sidebar.
        // On iPhone, meals are pushed as a new screen.
        // In both cases, meal card text appears in the view hierarchy.
        let mealText = app.staticTexts.matching(
            NSPredicate(
                format: "label != 'Categories' AND label != 'Beef' AND label != '' " +
                "AND label != 'Select a Category' AND label != 'Select a Meal' " +
                "AND label != 'Choose a category from the sidebar to browse meals.' " +
                "AND label != 'Choose a meal to see its details.'"
            )
        ).firstMatch
        XCTAssertTrue(mealText.waitForExistence(timeout: 15), "At least one meal should load")
        return mealText
    }

    /// Tap a meal and wait for detail to load
    @MainActor
    private func navigateToDetail(tapping mealText: XCUIElement) {
        mealText.tap()

        // Wait for detail content — Ingredients header is the reliable indicator
        let ingredientsHeader = app.staticTexts["Ingredients"]
        XCTAssertTrue(ingredientsHeader.waitForExistence(timeout: 15), "Ingredients section should appear")
    }

    // MARK: - Categories Screen

    @MainActor
    func testCategoriesListLoadsAndDisplaysItems() throws {
        _ = waitForCategories()

        XCTAssertTrue(app.cells.count >= 3, "Should display multiple categories")

        let beefText = app.staticTexts["Beef"]
        XCTAssertTrue(beefText.waitForExistence(timeout: 5), "Beef category should be displayed")
    }

    // MARK: - Navigation: Categories → Meals

    @MainActor
    func testTapCategoryNavigatesToMealsList() throws {
        let firstCell = waitForCategories()

        let beefCell = app.staticTexts["Beef"]
        XCTAssertTrue(beefCell.waitForExistence(timeout: 5))
        _ = navigateToMeals(tapping: beefCell)
    }

    // MARK: - Full Navigation: Categories → Meals → Detail

    @MainActor
    func testFullNavigationToMealDetail() throws {
        let firstCell = waitForCategories()
        let mealText = navigateToMeals(tapping: firstCell)

        navigateToDetail(tapping: mealText)

        let instructionsHeader = app.staticTexts["Instructions"]
        if !instructionsHeader.exists {
            app.scrollViews.firstMatch.swipeUp()
        }
        XCTAssertTrue(instructionsHeader.waitForExistence(timeout: 5), "Instructions section should appear")
    }

    // MARK: - Back Navigation

    @MainActor
    func testBackNavigationFromMealsToCategories() throws {
        // Skip on iPad — sidebar is always visible, no back navigation needed
        try XCTSkipIf(isIPad, "iPad uses split view — sidebar is always visible, no back button")

        let firstCell = waitForCategories()
        _ = navigateToMeals(tapping: firstCell)

        // Tap back
        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), "Back button should exist")
        backButton.tap()

        let categoriesNav = app.navigationBars["Categories"]
        XCTAssertTrue(categoriesNav.waitForExistence(timeout: 5), "Should navigate back to Categories")
        XCTAssertTrue(app.cells.firstMatch.exists, "Category cells should still be visible")
    }

    // MARK: - Detail Content Verification

    @MainActor
    func testMealDetailShowsYouTubeLink() throws {
        let firstCell = waitForCategories()
        let mealText = navigateToMeals(tapping: firstCell)
        navigateToDetail(tapping: mealText)

        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        let videoHeader = app.staticTexts["Video"]
        let youtubeLink = app.staticTexts["Watch on YouTube"]

        if videoHeader.exists {
            XCTAssertTrue(youtubeLink.exists, "YouTube link text should appear when Video section exists")
        }
    }
}
