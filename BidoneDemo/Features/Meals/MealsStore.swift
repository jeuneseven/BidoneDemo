//
//  MealsStore.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import Foundation
import Observation

@MainActor
@Observable
final class MealsStore {
    
    // MARK: - State
    private(set) var state: MealsState = .idle
    
    // MARK: - Current Category
    private(set) var currentCategory: String = ""
    
    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Intent Handling
    func send(_ intent: MealsIntent) {
        switch intent {
        case .loadMeals(let category):
            loadMeals(category: category)
        case .retry(let category):
            loadMeals(category: category)
        }
    }
    
    // MARK: - Private Methods
    private func loadMeals(category: String) {
        currentCategory = category
        state = .loading
        
        Task {
            do {
                let meals = try await networkService.fetchMeals(category: category)
                state = .loaded(meals)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
