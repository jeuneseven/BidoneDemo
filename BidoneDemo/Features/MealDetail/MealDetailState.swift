//
//  MealDetailState.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import Foundation

enum MealDetailState: Equatable {
    case idle
    case loading
    case loaded(MealDetail)
    case error(String)
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsDetail), .loaded(let rhsDetail)):
            return lhsDetail.id == rhsDetail.id
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
