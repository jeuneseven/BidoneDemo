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
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let detail):
            detailContent(detail)
            
        case .error(let message):
            errorView(message: message)
        }
    }
    
    // MARK: - Detail Content
    private func detailContent(_ detail: MealDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image
                headerImage(detail)
                
                VStack(alignment: .leading, spacing: 24) {
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
            .padding(.bottom, 32)
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
                .foregroundStyle(.secondary.opacity(0.3))
                .overlay {
                    ProgressView()
                }
        }
        .frame(height: 250)
        .clipped()
    }
    
    // MARK: - Info Section
    private func infoSection(_ detail: MealDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(detail.strMeal)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 12) {
                if let category = detail.strCategory {
                    Label(category, systemImage: "tag")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if let area = detail.strArea {
                    Label(area, systemImage: "globe")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Tags
            if !detail.tagsArray.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(detail.tagsArray, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.1))
                            .foregroundStyle(.background)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    // MARK: - Ingredients Section
    private func ingredientsSection(_ detail: MealDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(.headline)
            
            VStack(spacing: 8) {
                ForEach(Array(detail.ingredients.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Text(item.ingredient)
                            .font(.body)
                        
                        Spacer()
                        
                        Text(item.measure)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(index % 2 == 0 ? Color.secondary.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - Instructions Section
    private func instructionsSection(_ instructions: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.headline)
            
            Text(instructions)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
    }
    
    // MARK: - YouTube Section
    private func youtubeSection(_ urlString: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Video")
                .font(.headline)
            
            if let url = URL(string: urlString) {
                Link(destination: url) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                        
                        Text("Watch on YouTube")
                            .font(.body)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundStyle(.red)
                    .cornerRadius(12)
                }
            }
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
                store.send(.retry(id: meal.id))
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Flow Layout (for Tags)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, spacing: spacing, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, spacing: spacing, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in width: CGFloat, spacing: CGFloat, subviews: Subviews) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > width, x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                
                self.size.width = max(self.size.width, x - spacing)
            }
            
            self.size.height = y + rowHeight
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
