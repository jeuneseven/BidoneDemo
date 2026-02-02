//
//  CategoryState.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import Foundation

enum CategoriesState: Equatable {
    case idle
    case loading
    case loaded([Category])
    case error(String)
    
    static func == (lhs: CategoriesState, rhs: CategoriesState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsCategories), .loaded(let rhsCategories)):
            return lhsCategories.map { $0.id } == rhsCategories.map { $0.id }
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
