//
//  JSONDecodingTests.swift
//  BidoneDemoTests
//
//  Created by seven on 2026/2/3.
//

import Testing
import Foundation
@testable import BidoneDemo

@Suite("JSON Decoding Tests")
struct JSONDecodingTests {
    // MARK: - CategoriesResponse
    @Suite("CategoriesResponse Decoding")
    struct CategoriesResponseTests {
        @Test("Decodes valid categories JSON")
        func testDecodeCategoriesResponse() throws {
            let json = Data("""
            {
                "categories": [
                    {
                        "idCategory": "1",
                        "strCategory": "Beef",
                        "strCategoryThumb": "https://example.com/beef.png",
                        "strCategoryDescription": "Beef is the culinary name for meat from cattle."
                    }
                ]
            }
            """.utf8)
            
            let response = try JSONDecoder().decode(CategoriesResponse.self, from: json)
            #expect(response.categories.count == 1)
            #expect(response.categories[0].strCategory == "Beef")
            #expect(response.categories[0].idCategory == "1")
        }
        
        @Test("Decodes empty categories array")
        func testDecodeEmptyCategories() throws {
            let json = Data("""
            { "categories": [] }
            """.utf8)
            
            let response = try JSONDecoder().decode(CategoriesResponse.self, from: json)
            #expect(response.categories.isEmpty)
        }
    }
    
    // MARK: - MealsResponse
    @Suite("MealsResponse Decoding")
    struct MealsResponseTests {
        @Test("Decodes valid meals JSON")
        func testDecodeMealsResponse() throws {
            let json = Data("""
            {
                "meals": [
                    {
                        "idMeal": "52772",
                        "strMeal": "Teriyaki Chicken",
                        "strMealThumb": "https://example.com/teriyaki.jpg"
                    }
                ]
            }
            """.utf8)
            
            let response = try JSONDecoder().decode(MealsResponse.self, from: json)
            #expect(response.meals?.count == 1)
            #expect(response.meals?[0].idMeal == "52772")
        }
        
        @Test("Decodes null meals as nil")
        func testDecodeNullMeals() throws {
            let json = Data("""
            { "meals": null }
            """.utf8)
            
            let response = try JSONDecoder().decode(MealsResponse.self, from: json)
            #expect(response.meals == nil)
        }
    }
    
    // MARK: - MealDetailResponse
    @Suite("MealDetailResponse Decoding")
    struct MealDetailResponseTests {
        
        @Test("Decodes meal detail with all optional fields nil")
        func testDecodeMinimalMealDetail() throws {
            let json = Data("""
            {
                "meals": [
                    {
                        "idMeal": "1",
                        "strMeal": "Test Meal",
                        "strCategory": null,
                        "strArea": null,
                        "strInstructions": null,
                        "strMealThumb": null,
                        "strTags": null,
                        "strYoutube": null,
                        "strSource": null,
                        "strIngredient1": null, "strIngredient2": null, "strIngredient3": null,
                        "strIngredient4": null, "strIngredient5": null, "strIngredient6": null,
                        "strIngredient7": null, "strIngredient8": null, "strIngredient9": null,
                        "strIngredient10": null, "strIngredient11": null, "strIngredient12": null,
                        "strIngredient13": null, "strIngredient14": null, "strIngredient15": null,
                        "strIngredient16": null, "strIngredient17": null, "strIngredient18": null,
                        "strIngredient19": null, "strIngredient20": null,
                        "strMeasure1": null, "strMeasure2": null, "strMeasure3": null,
                        "strMeasure4": null, "strMeasure5": null, "strMeasure6": null,
                        "strMeasure7": null, "strMeasure8": null, "strMeasure9": null,
                        "strMeasure10": null, "strMeasure11": null, "strMeasure12": null,
                        "strMeasure13": null, "strMeasure14": null, "strMeasure15": null,
                        "strMeasure16": null, "strMeasure17": null, "strMeasure18": null,
                        "strMeasure19": null, "strMeasure20": null
                    }
                ]
            }
            """.utf8)
            
            let response = try JSONDecoder().decode(MealDetailResponse.self, from: json)
            let detail = try #require(response.meals?.first)
            #expect(detail.strMeal == "Test Meal")
            #expect(detail.strCategory == nil)
            #expect(detail.strArea == nil)
            #expect(detail.ingredients.isEmpty)
            #expect(detail.tagsArray.isEmpty)
        }
        
        @Test("Decodes null meals array as nil")
        func testDecodeNullMealDetail() throws {
            let json = Data("""
            { "meals": null }
            """.utf8)
            
            let response = try JSONDecoder().decode(MealDetailResponse.self, from: json)
            #expect(response.meals == nil)
        }
        
        @Test("Decodes meal detail with empty string ingredients from API")
        func testDecodeEmptyStringIngredients() throws {
            let json = Data("""
            {
                "meals": [
                    {
                        "idMeal": "1",
                        "strMeal": "Test",
                        "strCategory": "Test",
                        "strArea": "Test",
                        "strInstructions": "Cook it",
                        "strMealThumb": null,
                        "strTags": null,
                        "strYoutube": null,
                        "strSource": null,
                        "strIngredient1": "Chicken",
                        "strIngredient2": "",
                        "strIngredient3": " ",
                        "strIngredient4": null,
                        "strIngredient5": null, "strIngredient6": null,
                        "strIngredient7": null, "strIngredient8": null,
                        "strIngredient9": null, "strIngredient10": null,
                        "strIngredient11": null, "strIngredient12": null,
                        "strIngredient13": null, "strIngredient14": null,
                        "strIngredient15": null, "strIngredient16": null,
                        "strIngredient17": null, "strIngredient18": null,
                        "strIngredient19": null, "strIngredient20": null,
                        "strMeasure1": "1 lb",
                        "strMeasure2": "",
                        "strMeasure3": "",
                        "strMeasure4": null,
                        "strMeasure5": null, "strMeasure6": null,
                        "strMeasure7": null, "strMeasure8": null,
                        "strMeasure9": null, "strMeasure10": null,
                        "strMeasure11": null, "strMeasure12": null,
                        "strMeasure13": null, "strMeasure14": null,
                        "strMeasure15": null, "strMeasure16": null,
                        "strMeasure17": null, "strMeasure18": null,
                        "strMeasure19": null, "strMeasure20": null
                    }
                ]
            }
            """.utf8)
            
            let response = try JSONDecoder().decode(MealDetailResponse.self, from: json)
            let detail = try #require(response.meals?.first)
            
            // Only "Chicken" should be included; "" and " " should be filtered out
            #expect(detail.ingredients.count == 1)
            #expect(detail.ingredients[0].ingredient == "Chicken")
        }
    }
}
