//
//  CategoryStore.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import Foundation
import Observation

@Observable
final class CategoriesStore {
    
    // MARK: - State
    private(set) var state: CategoriesState = .idle
    
    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Intent Handling
    func send(_ intent: CategoriesIntent) {
        switch intent {
        case .loadCategories, .retry:
            loadCategories()
        }
    }
    
    // MARK: - Private Methods
    private func loadCategories() {
        state = .loading
        
        Task { @MainActor in
            do {
                let categories = try await networkService.fetchCategories()
                state = .loaded(categories)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
