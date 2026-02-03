//
//  CategoriesStoreTests.swift
//  BidoneDemoTests
//
//  Created by seven on 2026/2/3.
//

import Testing
import Foundation
@testable import BidoneDemo

@Suite("CategoriesStore Tests")
@MainActor
struct CategoriesStoreTests {
    // MARK: - Properties
    private let mockService: MockNetworkService
    private let store: CategoriesStore
    
    // MARK: - Init
    init() {
        mockService = MockNetworkService()
        store = CategoriesStore(networkService: mockService)
    }
    
    // MARK: - Initial State Tests
    @Test("Initial state should be idle")
    func testInitialState() {
        #expect(store.state == .idle)
    }
    
    // MARK: - Loading State Tests
    @Test("Sending loadCategories transitions to loading state synchronously")
    func testLoadingState() {
        mockService.mockCategories = TestData.allCategories
        
        store.send(.loadCategories)
        
        #expect(store.state == .loading)
    }
    
    // MARK: - Load Categories Tests
    @Test("Load categories successfully transitions to loaded state")
    func testLoadCategoriesSuccess() async throws {
        // Given
        mockService.mockCategories = TestData.allCategories
        
        // When
        store.send(.loadCategories)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .loaded(let categories) = store.state {
            #expect(categories.count == 3)
            #expect(categories[0].strCategory == "Beef")
            #expect(categories[1].strCategory == "Chicken")
            #expect(categories[2].strCategory == "Dessert")
        } else {
            Issue.record("Expected loaded state, got \(store.state)")
        }
        
        #expect(mockService.fetchCategoriesCallCount == 1)
    }
    
    @Test("Load categories with empty result")
    func testLoadCategoriesEmpty() async throws {
        // Given
        mockService.mockCategories = []
        
        // When
        store.send(.loadCategories)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .loaded(let categories) = store.state {
            #expect(categories.isEmpty)
        } else {
            Issue.record("Expected loaded state with empty array")
        }
    }
    
    @Test("Load categories failure transitions to error state")
    func testLoadCategoriesFailure() async throws {
        // Given
        mockService.shouldFail = true
        mockService.errorToThrow = NetworkError.serverError(500)
        
        // When
        store.send(.loadCategories)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .error(let message) = store.state {
            #expect(message.contains("500"))
        } else {
            Issue.record("Expected error state, got \(store.state)")
        }
    }
    
    @Test("Load categories with network error")
    func testLoadCategoriesNetworkError() async throws {
        // Given
        mockService.shouldFail = true
        mockService.errorToThrow = NetworkError.noData
        
        // When
        store.send(.loadCategories)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .error = store.state {
            // Success - we got an error state
        } else {
            Issue.record("Expected error state")
        }
    }
    
    // MARK: - Retry Tests
    @Test("Retry intent reloads categories")
    func testRetryReloadsCategories() async throws {
        // Given - First load fails
        mockService.shouldFail = true
        store.send(.loadCategories)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Verify error state
        guard case .error = store.state else {
            Issue.record("Expected error state before retry")
            return
        }
        
        // When - Retry with success
        mockService.shouldFail = false
        mockService.mockCategories = TestData.allCategories
        store.send(.retry)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        if case .loaded(let categories) = store.state {
            #expect(categories.count == 3)
        } else {
            Issue.record("Expected loaded state after retry")
        }
        
        #expect(mockService.fetchCategoriesCallCount == 2)
    }
}
