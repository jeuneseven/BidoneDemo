//
//  ContentView.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import SwiftUI

struct ContentView: View {
    // MARK: - State
    @State private var selectedCategory: Category?
    @State private var selectedMeal: Meal?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    // MARK: - Body
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            CategoriesSidebarView(
                selectedCategory: $selectedCategory,
                selectedMeal: $selectedMeal
            )
        } content: {
            if let category = selectedCategory {
                MealsColumnView(
                    category: category,
                    selectedMeal: $selectedMeal
                )
            } else {
                ContentUnavailableView(
                    Constants.Strings.selectCategoryTitle,
                    systemImage: Constants.Icons.category,
                    description: Text(Constants.Strings.selectCategoryDescription)
                )
            }
        } detail: {
            if let meal = selectedMeal {
                MealDetailView(meal: meal)
                    .id(meal.id)
            } else {
                ContentUnavailableView(
                    Constants.Strings.selectMealTitle,
                    systemImage: Constants.Icons.meal,
                    description: Text(Constants.Strings.selectMealDescription)
                )
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    ContentView()
}
