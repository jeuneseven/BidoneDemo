//
//  MealsState.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import Foundation

enum MealsState: Equatable {
    case idle
    case loading
    case loaded([Meal])
    case error(String)
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsMeals), .loaded(let rhsMeals)):
            return lhsMeals.map { $0.id } == rhsMeals.map { $0.id }
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
