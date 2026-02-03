//
//  MockNetworkService.swift
//  BidoneDemoTests
//
//  Created by seven on 2026/2/3.
//

import Testing
import Foundation
@testable import BidoneDemo

final class MockNetworkService: NetworkServiceProtocol {
    // MARK: - Configuration
    var shouldFail = false
    var errorToThrow: Error = NetworkError.unknown(NSError(domain: "Test", code: -1))
    var delay: UInt64 = 0
    
    // MARK: - Mock Data
    var mockCategories: [MealCategory] = []
    var mockMeals: [Meal] = []
    var mockMealDetail: MealDetail?
    
    // MARK: - Call Tracking
    var fetchCategoriesCallCount = 0
    var fetchMealsCallCount = 0
    var fetchMealDetailCallCount = 0
    var lastFetchMealsCategory: String?
    var lastFetchMealDetailId: String?
    
    // MARK: - NetworkServiceProtocol
    func fetchCategories() async throws -> [MealCategory] {
        fetchCategoriesCallCount += 1
        
        if delay > 0 {
            try await Task.sleep(nanoseconds: delay)
        }
        
        if shouldFail {
            throw errorToThrow
        }
        
        return mockCategories
    }
    
    func fetchMeals(category: String) async throws -> [Meal] {
        fetchMealsCallCount += 1
        lastFetchMealsCategory = category
        
        if delay > 0 {
            try await Task.sleep(nanoseconds: delay)
        }
        
        if shouldFail {
            throw errorToThrow
        }
        
        return mockMeals
    }
    
    func fetchMealDetail(id: String) async throws -> MealDetail? {
        fetchMealDetailCallCount += 1
        lastFetchMealDetailId = id
        
        if delay > 0 {
            try await Task.sleep(nanoseconds: delay)
        }
        
        if shouldFail {
            throw errorToThrow
        }
        
        return mockMealDetail
    }
    
    // MARK: - Reset
    func reset() {
        shouldFail = false
        errorToThrow = NetworkError.unknown(NSError(domain: "Test", code: -1))
        delay = 0
        mockCategories = []
        mockMeals = []
        mockMealDetail = nil
        fetchCategoriesCallCount = 0
        fetchMealsCallCount = 0
        fetchMealDetailCallCount = 0
        lastFetchMealsCategory = nil
        lastFetchMealDetailId = nil
    }
}
