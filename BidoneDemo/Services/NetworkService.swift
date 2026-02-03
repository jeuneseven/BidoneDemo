//
//  NetworkService.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import Foundation

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String(localized: "Invalid URL")
        case .noData:
            return String(localized: "No data received")
        case .decodingError:
            return String(localized: "Failed to decode response")
        case .serverError(let code):
            return String(localized: "Server error with code: \(code)")
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - API Endpoints
enum APIEndpoint {
    case categories
    case meals(category: String)
    case mealDetail(id: String)
    
    var url: String {
        switch self {
        case .categories:
            return "\(Constants.Network.baseURL)\(Constants.Network.Endpoints.categories)"
        case .meals(let category):
            return "\(Constants.Network.baseURL)\(Constants.Network.Endpoints.filter)?\(Constants.Network.QueryParams.category)=\(category)"
        case .mealDetail(let id):
            return "\(Constants.Network.baseURL)\(Constants.Network.Endpoints.lookup)?\(Constants.Network.QueryParams.id)=\(id)"
        }
    }
}

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol: Sendable {
    func fetchCategories() async throws -> [Category]
    func fetchMeals(category: String) async throws -> [Meal]
    func fetchMealDetail(id: String) async throws -> MealDetail?
}

// MARK: - Network Service Implementation
final class NetworkService: NetworkServiceProtocol, Sendable {
    static let shared = NetworkService()
    
    private init() {}
    
    // MARK: - Generic Fetch Method
    private func fetch<T: Codable>(from endpoint: APIEndpoint) async throws -> T {
        guard let url = URL(string: endpoint.url) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return result    
        } catch let error as NetworkError {
            throw error
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    // MARK: - Fetch Categories
    func fetchCategories() async throws -> [Category] {
        let response: CategoriesResponse = try await fetch(from: .categories)
        return response.categories
    }
    
    // MARK: - Fetch Meals by Category
    func fetchMeals(category: String) async throws -> [Meal] {
        let response: MealsResponse = try await fetch(from: .meals(category: category))
        return response.meals ?? []
    }
    
    // MARK: - Fetch Meal Detail
    func fetchMealDetail(id: String) async throws -> MealDetail? {
        let response: MealDetailResponse = try await fetch(from: .mealDetail(id: id))
        return response.meals?.first
    }
}
