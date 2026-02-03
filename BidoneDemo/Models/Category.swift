//
//  Category.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/2.
//

import Foundation

// MARK: - Categories API Response
struct CategoriesResponse: Codable {
    let categories: [Category]
}

struct Category: Codable, Identifiable, Hashable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
    
    var id: String { idCategory }
}
