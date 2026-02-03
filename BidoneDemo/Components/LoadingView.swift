//
//  LoadingView.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/3.
//

import SwiftUI

struct LoadingView: View {
    var message: String = Constants.Strings.loadingMessage
    
    var body: some View {
        ProgressView(message)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}
