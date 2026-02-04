//
//  MealsView.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import SwiftUI

// MARK: - Meals Column (used in NavigationSplitView)
struct MealsColumnView: View {
    // MARK: - Properties
    let category: Category
    @Binding var selectedMeal: Meal?

    // MARK: - Store
    @State private var store = MealsStore()

    // MARK: - Grid Columns (adaptive for iPhone and iPad)
    private let columns = [
        GridItem(.adaptive(minimum: Constants.Design.Size.mealCardMinWidth), spacing: Constants.Design.Spacing.large)
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
            .onChange(of: category) { _, newCategory in
                store.send(.loadMeals(category: newCategory.strCategory))
            }
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        switch store.state {
        case .idle:
            Color.clear

        case .loading:
            LoadingView()

        case .loaded(let meals):
            mealGrid(meals)

        case .error(let message):
            ErrorView(message: message) {
                store.send(.retry(category: category.strCategory))
            }
        }
    }

    // MARK: - Meal Grid
    private func mealGrid(_ meals: [Meal]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Constants.Design.Spacing.large) {
                ForEach(meals) { meal in
                    NavigationLink(value: meal) {
                        MealCard(meal: meal)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(meal.strMeal)
                }
            }
            .padding()
        }
        .navigationDestination(for: Meal.self) { meal in
            MealDetailView(meal: meal)
        }
    }
}

// MARK: - Standalone MealsView (for previews)
struct MealsView: View {
    let category: Category

    var body: some View {
        NavigationStack {
            MealsColumnView(category: category, selectedMeal: .constant(nil))
        }
    }
}

// MARK: - Meal Card
struct MealCard: View {
    let meal: Meal

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.Spacing.medium) {
            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .foregroundStyle(.secondary.opacity(Constants.Design.Opacity.placeholder))
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(height: Constants.Design.Size.mealCardImageHeight)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Design.CornerRadius.medium))
            .accessibilityHidden(true)

            Text(meal.strMeal)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        MealsColumnView(
            category: Category(
                idCategory: "1",
                strCategory: "Beef",
                strCategoryThumb: "https://www.themealdb.com/images/category/beef.png",
                strCategoryDescription: "Beef is meat from cattle."
            ),
            selectedMeal: .constant(nil)
        )
    }
}
