//
//  CategoriesView.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import SwiftUI

// MARK: - Categories Sidebar (used in NavigationSplitView)
struct CategoriesSidebarView: View {
    // MARK: - Bindings
    @Binding var selectedCategory: Category?
    @Binding var selectedMeal: Meal?

    // MARK: - Store
    @State private var store = CategoriesStore()

    // MARK: - Body
    var body: some View {
        content
            .navigationTitle(Constants.Strings.categoriesTitle)
            .onAppear {
                if case .idle = store.state {
                    store.send(.loadCategories)
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
            LoadingView()

        case .loaded(let categories):
            categoryList(categories)

        case .error(let message):
            ErrorView(message: message) {
                store.send(.retry)
            }
        }
    }

    // MARK: - Category List
    private func categoryList(_ categories: [Category]) -> some View {
        List(categories, selection: $selectedCategory) { category in
            CategoryRow(category: category)
                .tag(category)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCategory = category
                    selectedMeal = nil
                }
        }
        .listStyle(.plain)
    }
}

// MARK: - Standalone CategoriesView (for previews)
struct CategoriesView: View {
    var body: some View {
        ContentView()
    }
}

// MARK: - Category Row
struct CategoryRow: View {
    let category: Category

    var body: some View {
        HStack(spacing: Constants.Design.Spacing.regular) {
            AsyncImage(url: URL(string: category.strCategoryThumb)) { image in
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
            .frame(width: Constants.Design.Size.thumbnailSize, height: Constants.Design.Size.thumbnailSize)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Design.CornerRadius.small))
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: Constants.Design.Spacing.small) {
                Text(category.strCategory)
                    .font(.headline)

                Text(category.strCategoryDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, Constants.Design.Spacing.small)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview
#Preview {
    CategoriesView()
}
