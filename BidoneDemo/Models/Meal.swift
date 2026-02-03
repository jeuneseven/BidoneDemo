//
//  Meal.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import Foundation

// MARK: - Filter API Response (Meal List)
struct MealsResponse: Codable {
    let meals: [Meal]?
}

struct Meal: Codable, Identifiable, Hashable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
}
