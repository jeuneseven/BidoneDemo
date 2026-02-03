//
//  ModelTests.swift
//  BidoneDemoTests
//
//  Created by seven on 2026/2/3.
//

import Testing
import Foundation
@testable import BidoneDemo

@Suite("Model Tests")
struct ModelTests {
    // MARK: - MealDetail Ingredients Tests
    @Suite("MealDetail Ingredients")
    struct IngredientsTests {
        @Test("Ingredients returns non-empty ingredient-measure pairs")
        func testIngredientsComputed() {
            let detail = TestData.mealDetail1
            let ingredients = detail.ingredients
            
            #expect(ingredients.count == 4)
            #expect(ingredients[0].ingredient == "Chicken")
            #expect(ingredients[0].measure == "1 lb")
            #expect(ingredients[1].ingredient == "Soy Sauce")
            #expect(ingredients[1].measure == "3 tbsp")
            #expect(ingredients[2].ingredient == "Rice")
            #expect(ingredients[2].measure == "2 cups")
            #expect(ingredients[3].ingredient == "Honey")
            #expect(ingredients[3].measure == "2 tbsp")
        }
        
        @Test("Ingredients excludes nil values")
        func testIngredientsExcludesNil() {
            let detail = TestData.mealDetailNoTags
            let ingredients = detail.ingredients
            
            #expect(ingredients.count == 1)
            #expect(ingredients[0].ingredient == "Salt")
        }
        
        @Test("Ingredients excludes empty and whitespace-only strings")
        func testIngredientsExcludesEmptyAndWhitespace() {
            let detail = TestData.mealDetailWithEmptyIngredients
            let ingredients = detail.ingredients
            
            #expect(ingredients.count == 1)
            #expect(ingredients[0].ingredient == "Butter")
        }
        
        @Test("Ingredients returns empty string for nil measure")
        func testIngredientsMeasureFallback() {
            let detail = TestData.mealDetailNilMeasure
            let ingredients = detail.ingredients
            
            #expect(ingredients.count == 1)
            #expect(ingredients[0].ingredient == "Pepper")
            #expect(ingredients[0].measure == "")
        }
    }
    
    // MARK: - MealDetail Tags Tests
    @Suite("MealDetail Tags")
    struct TagsTests {
        @Test("Tags parses comma-separated string")
        func testTagsArrayComputed() {
            let detail = TestData.mealDetail1
            let tags = detail.tagsArray
            
            #expect(tags.count == 2)
            #expect(tags[0] == "Meat")
            #expect(tags[1] == "Casserole")
        }
        
        @Test("Tags returns empty array when strTags is nil")
        func testTagsArrayNil() {
            let detail = TestData.mealDetailNoTags
            #expect(detail.tagsArray.isEmpty)
        }
        
        @Test("Tags trims whitespace from each tag")
        func testTagsArrayTrimsWhitespace() {
            let detail = MealDetail(
                idMeal: "1",
                strMeal: "Test",
                strCategory: nil,
                strArea: nil,
                strInstructions: nil,
                strMealThumb: nil,
                strTags: "  Spicy  ,  Quick  ,Easy  ",
                strYoutube: nil,
                strSource: nil,
                strIngredient1: nil, strIngredient2: nil, strIngredient3: nil, strIngredient4: nil, strIngredient5: nil,
                strIngredient6: nil, strIngredient7: nil, strIngredient8: nil, strIngredient9: nil, strIngredient10: nil,
                strIngredient11: nil, strIngredient12: nil, strIngredient13: nil, strIngredient14: nil, strIngredient15: nil,
                strIngredient16: nil, strIngredient17: nil, strIngredient18: nil, strIngredient19: nil, strIngredient20: nil,
                strMeasure1: nil, strMeasure2: nil, strMeasure3: nil, strMeasure4: nil, strMeasure5: nil,
                strMeasure6: nil, strMeasure7: nil, strMeasure8: nil, strMeasure9: nil, strMeasure10: nil,
                strMeasure11: nil, strMeasure12: nil, strMeasure13: nil, strMeasure14: nil, strMeasure15: nil,
                strMeasure16: nil, strMeasure17: nil, strMeasure18: nil, strMeasure19: nil, strMeasure20: nil
            )
            
            let tags = detail.tagsArray
            #expect(tags.count == 3)
            #expect(tags[0] == "Spicy")
            #expect(tags[1] == "Quick")
            #expect(tags[2] == "Easy")
        }
    }
}
