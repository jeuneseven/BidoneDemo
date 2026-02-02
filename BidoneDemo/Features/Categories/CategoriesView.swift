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
                .navigationTitle("Categories")
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
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let categories):
            categoryList(categories)
            
        case .error(let message):
            errorView(message: message)
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
                store.send(.retry)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Category Row
struct CategoryRow: View {
    let category: Category
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: category.strCategoryThumb)) { image in
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
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.strCategory)
                    .font(.headline)
                
                Text(category.strCategoryDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    CategoriesView()
}
