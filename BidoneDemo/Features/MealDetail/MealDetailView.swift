//
//  MealDetailView.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import SwiftUI

struct MealDetailView: View {
    // MARK: - Properties
    let meal: Meal
    
    // MARK: - Store
    @State private var store = MealDetailStore()
    
    // MARK: - Body
    var body: some View {
        content
            .navigationTitle(meal.strMeal)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if case .idle = store.state {
                    store.send(.loadDetail(id: meal.id))
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
            
        case .loaded(let detail):
            detailContent(detail)
            
        case .error(let message):
            ErrorView(message: message) {
                store.send(.retry(id: meal.id))
            }
        }
    }
    
    // MARK: - Detail Content
    private func detailContent(_ detail: MealDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.Design.Spacing.xLarge) {
                // Header Image
                headerImage(detail)
                
                VStack(alignment: .leading, spacing: Constants.Design.Spacing.xxLarge) {
                    // Tags and Info
                    infoSection(detail)
                    
                    // Ingredients
                    if !detail.ingredients.isEmpty {
                        ingredientsSection(detail)
                    }
                    
                    // Instructions
                    if let instructions = detail.strInstructions, !instructions.isEmpty {
                        instructionsSection(instructions)
                    }
                    
                    // YouTube Link
                    if let youtube = detail.strYoutube, !youtube.isEmpty {
                        youtubeSection(youtube)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, Constants.Design.Spacing.xxxLarge)
        }
    }
    
    // MARK: - Header Image
    private func headerImage(_ detail: MealDetail) -> some View {
        AsyncImage(url: URL(string: detail.strMealThumb ?? "")) { image in
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
        .frame(height: Constants.Design.Size.headerImageHeight)
        .clipped()
        .accessibilityLabel(Constants.Strings.Accessibility.mealPhoto(detail.strMeal))
    }
    
    // MARK: - Info Section
    private func infoSection(_ detail: MealDetail) -> some View {
        VStack(alignment: .leading, spacing: Constants.Design.Spacing.regular) {
            Text(detail.strMeal)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: Constants.Design.Spacing.regular) {
                if let category = detail.strCategory {
                    Label(category, systemImage: Constants.Icons.tag)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if let area = detail.strArea {
                    Label(area, systemImage: Constants.Icons.globe)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Tags
            if !detail.tagsArray.isEmpty {
                FlowLayout(spacing: Constants.Design.Spacing.medium) {
                    ForEach(detail.tagsArray, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, Constants.Design.TagPadding.horizontal)
                            .padding(.vertical, Constants.Design.TagPadding.vertical)
                            .background(Color.accentColor.opacity(Constants.Design.Opacity.backgroundLight))
                            .foregroundStyle(Color.accentColor)
                            .clipShape(Capsule())
                            .accessibilityLabel(Constants.Strings.Accessibility.tag(tag))
                    }
                }
            }
        }
    }
    
    // MARK: - Ingredients Section
    private func ingredientsSection(_ detail: MealDetail) -> some View {
        VStack(alignment: .leading, spacing: Constants.Design.Spacing.regular) {
            Text(Constants.Strings.ingredientsTitle)
                .font(.headline)
            
            VStack(spacing: Constants.Design.Spacing.medium) {
                ForEach(Array(detail.ingredients.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Text(item.ingredient)
                            .font(.body)
                        
                        Spacer()
                        
                        Text(item.measure)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, Constants.Design.Spacing.medium)
                    .padding(.horizontal, Constants.Design.Spacing.regular)
                    .background(index.isMultiple(of: 2) ? Color.secondary.opacity(Constants.Design.Opacity.backgroundLight) : Color.clear)
                    .cornerRadius(Constants.Design.CornerRadius.small)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Constants.Strings.Accessibility.ingredientRow(item.ingredient, item.measure))
                }
            }
        }
    }
    
    // MARK: - Instructions Section
    private func instructionsSection(_ instructions: String) -> some View {
        VStack(alignment: .leading, spacing: Constants.Design.Spacing.regular) {
            Text(Constants.Strings.instructionsTitle)
                .font(.headline)
            
            Text(instructions)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(Constants.Design.instructionLineSpacing)
        }
    }
    
    // MARK: - YouTube Section
    private func youtubeSection(_ urlString: String) -> some View {
        VStack(alignment: .leading, spacing: Constants.Design.Spacing.regular) {
            Text(Constants.Strings.videoTitle)
                .font(.headline)
            
            if let url = URL(string: urlString) {
                Link(destination: url) {
                    HStack {
                        Image(systemName: Constants.Icons.play)
                            .font(.title2)
                        
                        Text(Constants.Strings.watchOnYouTube)
                            .font(.body)
                        
                        Spacer()
                        
                        Image(systemName: Constants.Icons.externalLink)
                    }
                    .padding()
                    .background(Constants.Colors.youtubeRed.opacity(Constants.Design.Opacity.backgroundLight))
                    .foregroundStyle(Constants.Colors.youtubeRed)
                    .cornerRadius(Constants.Design.CornerRadius.medium)
                }
                .accessibilityLabel(Constants.Strings.Accessibility.youtubeLink)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        MealDetailView(meal: Meal(
            idMeal: "52772",
            strMeal: "Teriyaki Chicken Casserole",
            strMealThumb: "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg"
        ))
    }
}
