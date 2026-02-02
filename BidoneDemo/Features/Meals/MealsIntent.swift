//
//  MealsIntent.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import Foundation

enum MealsIntent {
    case loadMeals(category: String)
    case retry(category: String)
}
