//
//  APIEndpointTests.swift
//  BidoneDemoTests
//
//  Created by seven on 2026/2/3.
//

import Testing
import Foundation
@testable import BidoneDemo

@Suite("APIEndpoint Tests")
struct APIEndpointTests {
    
    @Test("Categories endpoint builds correct URL")
    func testCategoriesURL() {
        let url = APIEndpoint.categories.url
        #expect(url == "https://www.themealdb.com/api/json/v1/1/categories.php")
    }
    
    @Test("Meals endpoint builds correct URL with category parameter")
    func testMealsURL() {
        let url = APIEndpoint.meals(category: "Chicken").url
        #expect(url == "https://www.themealdb.com/api/json/v1/1/filter.php?c=Chicken")
    }
    
    @Test("Meal detail endpoint builds correct URL with id parameter")
    func testMealDetailURL() {
        let url = APIEndpoint.mealDetail(id: "52772").url
        #expect(url == "https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772")
    }
    
    @Test("Meals endpoint handles special characters in category")
    func testMealsURLSpecialCharacters() {
        let url = APIEndpoint.meals(category: "Side Dish").url
        #expect(url.contains("c=Side Dish"))
    }
}
