//
//  CategoriesView.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import SwiftUI

struct CategoriesView: View {
    // MARK: - Store
    @State private var store = CategoriesStore()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(Constants.Strings.categoriesTitle)
        }
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
        List(categories) { category in
            NavigationLink(value: category) {
                CategoryRow(category: category)
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: Category.self) { category in
            MealsView(category: category)
        }
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
