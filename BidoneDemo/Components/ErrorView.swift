//
//  ErrorView.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/3.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: Constants.Design.Spacing.large) {
            Image(systemName: Constants.Icons.error)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            
            Text(message)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(Constants.Strings.retryButton, action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorView(message: "Something went wrong") {
        print("Retry tapped")
    }
}
