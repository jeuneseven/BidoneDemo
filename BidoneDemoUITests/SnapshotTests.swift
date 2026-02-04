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
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    // MARK: - Screenshots

    @MainActor
    func testScreenshots() throws {
        // ── 1. Categories screen ──
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 30), "Categories should load")
        snapshot("01_Categories")

        // ── 2. Tap "Beef" category → Meals screen ──
        let beefText = app.staticTexts["Beef"]
        XCTAssertTrue(beefText.waitForExistence(timeout: 10), "Beef category should exist")
        beefText.tap()

        // Wait for meal cards to load (API call).
        // Use NSPredicate to exclude known non-meal labels.
        let mealCard = app.staticTexts.matching(
            NSPredicate(
                format: "label != 'Categories' AND label != 'Beef' AND label != '' " +
                "AND label != 'Select a Category' AND label != 'Select a Meal' " +
                "AND label != 'Choose a category from the sidebar to browse meals.' " +
                "AND label != 'Choose a meal to see its details.' " +
                "AND label != 'Loading...'"
            )
        ).firstMatch
        XCTAssertTrue(mealCard.waitForExistence(timeout: 30), "At least one meal should load")
        snapshot("02_Meals")

        // ── 3. Tap first meal → Detail screen ──
        mealCard.tap()

        // Wait for detail content
        let ingredientsHeader = app.staticTexts["Ingredients"]
        XCTAssertTrue(
            ingredientsHeader.waitForExistence(timeout: 30),
            "Detail page should load with Ingredients section"
        )

        // Wait for images to render
        sleep(3)
        snapshot("03_MealDetail_Top")

        // ── 4. Scroll down ──
        // On iPad, all three columns are visible. We need to scroll the detail
        // column specifically — find the last (rightmost) ScrollView.
        if isIPad {
            let scrollViews = app.scrollViews
            let lastScroll = scrollViews.element(boundBy: scrollViews.count - 1)
            if lastScroll.exists {
                lastScroll.swipeUp()
            }
        } else {
            let detailScroll = app.scrollViews.firstMatch
            if detailScroll.exists {
                detailScroll.swipeUp()
            } else {
                app.swipeUp()
            }
        }
        sleep(1)
        snapshot("04_MealDetail_Bottom")
    }
}
