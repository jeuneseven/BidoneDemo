//
//  MealDetailStore.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import Foundation
import Observation

@MainActor
@Observable
final class MealDetailStore {
    
    // MARK: - State
    private(set) var state: MealDetailState = .idle
    
    // MARK: - Current Meal ID
    private(set) var currentMealId: String = ""
    
    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Intent Handling
    func send(_ intent: MealDetailIntent) {
        switch intent {
        case .loadDetail(let id):
            loadDetail(id: id)
        case .retry(let id):
            loadDetail(id: id)
        }
    }
    
    // MARK: - Private Methods
    private func loadDetail(id: String) {
        currentMealId = id
        state = .loading
        
        Task {
            do {
                if let detail = try await networkService.fetchMealDetail(id: id) {
                    state = .loaded(detail)
                } else {
                    state = .error(Constants.Strings.mealNotFound)
                }
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
