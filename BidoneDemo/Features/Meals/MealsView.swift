//
//  MealsView.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import SwiftUI

struct MealsView: View {
    
    // MARK: - Properties
    let category: Category
    
    // MARK: - Store
    @State private var store = MealsStore()
    
    // MARK: - Grid Columns
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // MARK: - Body
    var body: some View {
        content
            .navigationTitle(category.strCategory)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                if case .idle = store.state {
                    store.send(.loadMeals(category: category.strCategory))
                }
            }
    }
    
    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        switch store.state {
        case .idle:
            Color.clear
            
        case .loading:
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let meals):
            mealGrid(meals)
            
        case .error(let message):
            errorView(message: message)
        }
    }
    
    // MARK: - Meal Grid
    private func mealGrid(_ meals: [Meal]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(meals) { meal in
                    NavigationLink(value: meal) {
                        MealCard(meal: meal)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationDestination(for: Meal.self) { meal in
            MealDetailView(meal: meal)
        }
    }
    
    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            
            Text(message)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                store.send(.retry(category: category.strCategory))
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Meal Card
struct MealCard: View {
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .foregroundStyle(.secondary.opacity(0.3))
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(meal.strMeal)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        MealsView(category: Category(
            idCategory: "1",
            strCategory: "Beef",
            strCategoryThumb: "https://www.themealdb.com/images/category/beef.png",
            strCategoryDescription: "Beef is meat from cattle."
        ))
    }
}
