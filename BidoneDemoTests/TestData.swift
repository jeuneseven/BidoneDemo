//
//  TestData.swift
//  BidoneDemoTests
//
//  Created by seven on 2026/2/3.
//

import Testing
@testable import BidoneDemo

// Type alias to resolve ambiguity with Foundation's Category
typealias MealCategory = BidoneDemo.Category

enum TestData {
    
    // MARK: - Categories
    static let category1 = MealCategory(
        idCategory: "1",
        strCategory: "Beef",
        strCategoryThumb: "https://example.com/beef.png",
        strCategoryDescription: "Beef is meat from cattle."
    )
    
    static let category2 = MealCategory(
        idCategory: "2",
        strCategory: "Chicken",
        strCategoryThumb: "https://example.com/chicken.png",
        strCategoryDescription: "Chicken is poultry."
    )
    
    static let category3 = MealCategory(
        idCategory: "3",
        strCategory: "Dessert",
        strCategoryThumb: "https://example.com/dessert.png",
        strCategoryDescription: "Sweet treats and desserts."
    )
    
    static var allCategories: [MealCategory] {
        [category1, category2, category3]
    }
    
    // MARK: - Meals
    static let meal1 = Meal(
        idMeal: "52772",
        strMeal: "Teriyaki Chicken Casserole",
        strMealThumb: "https://example.com/teriyaki.jpg"
    )
    
    static let meal2 = Meal(
        idMeal: "52773",
        strMeal: "Honey Teriyaki Salmon",
        strMealThumb: "https://example.com/salmon.jpg"
    )
    
    static let meal3 = Meal(
        idMeal: "52774",
        strMeal: "Pad Thai",
        strMealThumb: "https://example.com/padthai.jpg"
    )
    
    static var allMeals: [Meal] {
        [meal1, meal2, meal3]
    }
    
    // MARK: - Meal Detail
    static let mealDetail1 = MealDetail(
        idMeal: "52772",
        strMeal: "Teriyaki Chicken Casserole",
        strCategory: "Chicken",
        strArea: "Japanese",
        strInstructions: "Preheat oven to 350°F. Season chicken with salt and pepper. Cook rice according to package directions.",
        strMealThumb: "https://example.com/teriyaki.jpg",
        strTags: "Meat,Casserole",
        strYoutube: "https://www.youtube.com/watch?v=4aZr5hZXP_s",
        strSource: "https://example.com/recipe",
        strIngredient1: "Chicken",
        strIngredient2: "Soy Sauce",
        strIngredient3: "Rice",
        strIngredient4: "Honey",
        strIngredient5: nil,
        strIngredient6: nil,
        strIngredient7: nil,
        strIngredient8: nil,
        strIngredient9: nil,
        strIngredient10: nil,
        strIngredient11: nil,
        strIngredient12: nil,
        strIngredient13: nil,
        strIngredient14: nil,
        strIngredient15: nil,
        strIngredient16: nil,
        strIngredient17: nil,
        strIngredient18: nil,
        strIngredient19: nil,
        strIngredient20: nil,
        strMeasure1: "1 lb",
        strMeasure2: "3 tbsp",
        strMeasure3: "2 cups",
        strMeasure4: "2 tbsp",
        strMeasure5: nil,
        strMeasure6: nil,
        strMeasure7: nil,
        strMeasure8: nil,
        strMeasure9: nil,
        strMeasure10: nil,
        strMeasure11: nil,
        strMeasure12: nil,
        strMeasure13: nil,
        strMeasure14: nil,
        strMeasure15: nil,
        strMeasure16: nil,
        strMeasure17: nil,
        strMeasure18: nil,
        strMeasure19: nil,
        strMeasure20: nil
    )
    
    static let mealDetailNoTags = MealDetail(
        idMeal: "52773",
        strMeal: "Simple Dish",
        strCategory: "Misc",
        strArea: nil,
        strInstructions: "Just cook it.",
        strMealThumb: nil,
        strTags: nil,
        strYoutube: nil,
        strSource: nil,
        strIngredient1: "Salt",
        strIngredient2: nil,
        strIngredient3: nil,
        strIngredient4: nil,
        strIngredient5: nil,
        strIngredient6: nil,
        strIngredient7: nil,
        strIngredient8: nil,
        strIngredient9: nil,
        strIngredient10: nil,
        strIngredient11: nil,
        strIngredient12: nil,
        strIngredient13: nil,
        strIngredient14: nil,
        strIngredient15: nil,
        strIngredient16: nil,
        strIngredient17: nil,
        strIngredient18: nil,
        strIngredient19: nil,
        strIngredient20: nil,
        strMeasure1: "1 tsp",
        strMeasure2: nil,
        strMeasure3: nil,
        strMeasure4: nil,
        strMeasure5: nil,
        strMeasure6: nil,
        strMeasure7: nil,
        strMeasure8: nil,
        strMeasure9: nil,
        strMeasure10: nil,
        strMeasure11: nil,
        strMeasure12: nil,
        strMeasure13: nil,
        strMeasure14: nil,
        strMeasure15: nil,
        strMeasure16: nil,
        strMeasure17: nil,
        strMeasure18: nil,
        strMeasure19: nil,
        strMeasure20: nil
    )
    
    // MARK: - Edge Case: Empty and whitespace-only ingredients
    static let mealDetailWithEmptyIngredients = MealDetail(
        idMeal: "99901",
        strMeal: "Edge Case Dish",
        strCategory: nil,
        strArea: nil,
        strInstructions: nil,
        strMealThumb: nil,
        strTags: nil,
        strYoutube: nil,
        strSource: nil,
        strIngredient1: "",
        strIngredient2: "   ",
        strIngredient3: "Butter",
        strIngredient4: nil,
        strIngredient5: nil,
        strIngredient6: nil,
        strIngredient7: nil,
        strIngredient8: nil,
        strIngredient9: nil,
        strIngredient10: nil,
        strIngredient11: nil,
        strIngredient12: nil,
        strIngredient13: nil,
        strIngredient14: nil,
        strIngredient15: nil,
        strIngredient16: nil,
        strIngredient17: nil,
        strIngredient18: nil,
        strIngredient19: nil,
        strIngredient20: nil,
        strMeasure1: "1 tbsp",
        strMeasure2: "2 tsp",
        strMeasure3: "100g",
        strMeasure4: nil,
        strMeasure5: nil,
        strMeasure6: nil,
        strMeasure7: nil,
        strMeasure8: nil,
        strMeasure9: nil,
        strMeasure10: nil,
        strMeasure11: nil,
        strMeasure12: nil,
        strMeasure13: nil,
        strMeasure14: nil,
        strMeasure15: nil,
        strMeasure16: nil,
        strMeasure17: nil,
        strMeasure18: nil,
        strMeasure19: nil,
        strMeasure20: nil
    )
    
    // MARK: - Edge Case: Ingredient with nil measure
    static let mealDetailNilMeasure = MealDetail(
        idMeal: "99902",
        strMeal: "Nil Measure Dish",
        strCategory: nil,
        strArea: nil,
        strInstructions: nil,
        strMealThumb: nil,
        strTags: nil,
        strYoutube: nil,
        strSource: nil,
        strIngredient1: "Pepper",
        strIngredient2: nil,
        strIngredient3: nil,
        strIngredient4: nil,
        strIngredient5: nil,
        strIngredient6: nil,
        strIngredient7: nil,
        strIngredient8: nil,
        strIngredient9: nil,
        strIngredient10: nil,
        strIngredient11: nil,
        strIngredient12: nil,
        strIngredient13: nil,
        strIngredient14: nil,
        strIngredient15: nil,
        strIngredient16: nil,
        strIngredient17: nil,
        strIngredient18: nil,
        strIngredient19: nil,
        strIngredient20: nil,
        strMeasure1: nil,
        strMeasure2: nil,
        strMeasure3: nil,
        strMeasure4: nil,
        strMeasure5: nil,
        strMeasure6: nil,
        strMeasure7: nil,
        strMeasure8: nil,
        strMeasure9: nil,
        strMeasure10: nil,
        strMeasure11: nil,
        strMeasure12: nil,
        strMeasure13: nil,
        strMeasure14: nil,
        strMeasure15: nil,
        strMeasure16: nil,
        strMeasure17: nil,
        strMeasure18: nil,
        strMeasure19: nil,
        strMeasure20: nil
    )
}
