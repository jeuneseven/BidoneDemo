//
//  MealDetailStoreTests.swift
//  BidoneDemoTests
//
//  Created by seven on 2026/2/3.
//

import Testing
import Foundation
@testable import BidoneDemo

@Suite("MealDetailStore Tests")
@MainActor
struct MealDetailStoreTests {
    
    // MARK: - Properties
    private let mockService: MockNetworkService
    private let store: MealDetailStore
    
    // MARK: - Init
    init() {
        mockService = MockNetworkService()
        store = MealDetailStore(networkService: mockService)
    }
    
    // MARK: - Initial State Tests
    @Test("Initial state should be idle")
    func testInitialState() {
        #expect(store.state == .idle)
        #expect(store.currentMealId == "")
    }
    
    // MARK: - Loading State Tests
    @Test("Sending loadDetail transitions to loading state synchronously")
    func testLoadingState() {
        mockService.mockMealDetail = TestData.mealDetail1
        
        store.send(.loadDetail(id: "52772"))
        
        #expect(store.state == .loading)
        #expect(store.currentMealId == "52772")
    }
    
    // MARK: - Load Detail Tests
    @Test("Load meal detail successfully transitions to loaded state")
    func testLoadDetailSuccess() async throws {
        // Given
        mockService.mockMealDetail = TestData.mealDetail1
        let mealId = "52772"
        
        // When
        store.send(.loadDetail(id: mealId))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(store.currentMealId == mealId)
        if case .loaded(let detail) = store.state {
            #expect(detail.idMeal == "52772")
            #expect(detail.strMeal == "Teriyaki Chicken Casserole")
            #expect(detail.strCategory == "Chicken")
            #expect(detail.strArea == "Japanese")
        } else {
            Issue.record("Expected loaded state, got \(store.state)")
        }
        
        #expect(mockService.fetchMealDetailCallCount == 1)
        #expect(mockService.lastFetchMealDetailId == mealId)
    }
    
    @Test("Load meal detail with nil result transitions to error state")
    func testLoadDetailNotFound() async throws {
        // Given
        mockService.mockMealDetail = nil
        
        // When
        store.send(.loadDetail(id: "99999"))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .error(let message) = store.state {
            #expect(message == "Meal not found")
        } else {
            Issue.record("Expected error state, got \(store.state)")
        }
    }
    
    @Test("Load meal detail failure transitions to error state")
    func testLoadDetailFailure() async throws {
        // Given
        mockService.shouldFail = true
        mockService.errorToThrow = NetworkError.decodingError
        
        // When
        store.send(.loadDetail(id: "52772"))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .error = store.state {
            // Success - we got an error state
        } else {
            Issue.record("Expected error state, got \(store.state)")
        }
    }
    
    @Test("Load different meal details updates current meal id")
    func testLoadDifferentMeals() async throws {
        // Given
        mockService.mockMealDetail = TestData.mealDetail1
        
        // When - Load first meal
        store.send(.loadDetail(id: "52772"))
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(store.currentMealId == "52772")
        
        // When - Load second meal
        mockService.mockMealDetail = TestData.mealDetailNoTags
        store.send(.loadDetail(id: "52773"))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(store.currentMealId == "52773")
        if case .loaded(let detail) = store.state {
            #expect(detail.strMeal == "Simple Dish")
        } else {
            Issue.record("Expected loaded state")
        }
        
        #expect(mockService.fetchMealDetailCallCount == 2)
    }
    
    // MARK: - Retry Tests
    @Test("Retry intent reloads meal detail")
    func testRetryReloadsDetail() async throws {
        // Given - First load fails
        mockService.shouldFail = true
        store.send(.loadDetail(id: "52772"))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Verify error state
        guard case .error = store.state else {
            Issue.record("Expected error state before retry")
            return
        }
        
        // When - Retry with success
        mockService.shouldFail = false
        mockService.mockMealDetail = TestData.mealDetail1
        store.send(.retry(id: "52772"))
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .loaded(let detail) = store.state {
            #expect(detail.strMeal == "Teriyaki Chicken Casserole")
        } else {
            Issue.record("Expected loaded state after retry")
        }
        
        #expect(mockService.fetchMealDetailCallCount == 2)
    }
}
