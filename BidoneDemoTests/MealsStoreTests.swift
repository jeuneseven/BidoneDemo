//
//  MealsStoreTests.swift
//  BidoneDemoTests
//
//  Created by seven on 2026/2/3.
//

import Testing
import Foundation
@testable import BidoneDemo

@Suite("MealsStore Tests")
@MainActor
struct MealsStoreTests {
    
    // MARK: - Properties
    private let mockService: MockNetworkService
    private let store: MealsStore
    
    // MARK: - Init
    init() {
        mockService = MockNetworkService()
        store = MealsStore(networkService: mockService)
    }
    
    // MARK: - Initial State Tests
    @Test("Initial state should be idle")
    func testInitialState() {
        #expect(store.state == .idle)
        #expect(store.currentCategory == "")
    }
    
    // MARK: - Loading State Tests
    @Test("Sending loadMeals transitions to loading state synchronously")
    func testLoadingState() {
        mockService.mockMeals = TestData.allMeals
        
        store.send(.loadMeals(category: "Chicken"))
        
        #expect(store.state == .loading)
        #expect(store.currentCategory == "Chicken")
    }
    
    // MARK: - Load Meals Tests
    @Test("Load meals successfully transitions to loaded state")
    func testLoadMealsSuccess() async throws {
        // Given
        mockService.mockMeals = TestData.allMeals
        let category = "Chicken"
        
        // When
        store.send(.loadMeals(category: category))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(store.currentCategory == category)
        if case .loaded(let meals) = store.state {
            #expect(meals.count == 3)
            #expect(meals[0].strMeal == "Teriyaki Chicken Casserole")
        } else {
            Issue.record("Expected loaded state, got \(store.state)")
        }
        
        #expect(mockService.fetchMealsCallCount == 1)
        #expect(mockService.lastFetchMealsCategory == category)
    }
    
    @Test("Load meals with empty result")
    func testLoadMealsEmpty() async throws {
        // Given
        mockService.mockMeals = []
        
        // When
        store.send(.loadMeals(category: "Empty"))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .loaded(let meals) = store.state {
            #expect(meals.isEmpty)
        } else {
            Issue.record("Expected loaded state with empty array")
        }
    }
    
    @Test("Load meals failure transitions to error state")
    func testLoadMealsFailure() async throws {
        // Given
        mockService.shouldFail = true
        mockService.errorToThrow = NetworkError.serverError(404)
        
        // When
        store.send(.loadMeals(category: "Unknown"))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .error(let message) = store.state {
            #expect(message.contains("404"))
        } else {
            Issue.record("Expected error state, got \(store.state)")
        }
    }
    
    @Test("Load meals for different categories")
    func testLoadMealsDifferentCategories() async throws {
        // Given
        mockService.mockMeals = [TestData.meal1]
        
        // When - Load first category
        store.send(.loadMeals(category: "Beef"))
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(store.currentCategory == "Beef")
        
        // When - Load second category
        mockService.mockMeals = [TestData.meal2, TestData.meal3]
        store.send(.loadMeals(category: "Seafood"))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(store.currentCategory == "Seafood")
        if case .loaded(let meals) = store.state {
            #expect(meals.count == 2)
        } else {
            Issue.record("Expected loaded state")
        }
        
        #expect(mockService.fetchMealsCallCount == 2)
    }
    
    // MARK: - Retry Tests
    @Test("Retry intent reloads meals for current category")
    func testRetryReloadsMeals() async throws {
        // Given - First load fails
        mockService.shouldFail = true
        store.send(.loadMeals(category: "Chicken"))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Verify error state
        guard case .error = store.state else {
            Issue.record("Expected error state before retry")
            return
        }
        
        // When - Retry with success
        mockService.shouldFail = false
        mockService.mockMeals = TestData.allMeals
        store.send(.retry(category: "Chicken"))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .loaded(let meals) = store.state {
            #expect(meals.count == 3)
        } else {
            Issue.record("Expected loaded state after retry")
        }
        
        #expect(mockService.fetchMealsCallCount == 2)
        #expect(mockService.lastFetchMealsCategory == "Chicken")
    }
}
