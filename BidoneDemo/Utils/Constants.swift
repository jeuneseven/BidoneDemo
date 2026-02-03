//
//  Constants.swift
//  BidoneDemo
//
//  Created by seven on 2026/2/3.
//

import Foundation
import SwiftUI

enum Constants {
    // MARK: - Design System
    enum Design {
        // MARK: Spacing
        enum Spacing {
            static let small: CGFloat = 4
            static let medium: CGFloat = 8
            static let regular: CGFloat = 12
            static let large: CGFloat = 16
            static let xLarge: CGFloat = 20
            static let xxLarge: CGFloat = 24
            static let xxxLarge: CGFloat = 32
        }
        
        // MARK: Corner Radius
        enum CornerRadius {
            static let small: CGFloat = 8
            static let medium: CGFloat = 12
            static let large: CGFloat = 16
        }
        
        // MARK: Sizes
        enum Size {
            static let thumbnailSize: CGFloat = 60
            static let mealCardImageHeight: CGFloat = 140
            static let headerImageHeight: CGFloat = 250
        }
        
        // MARK: Opacity
        enum Opacity {
            static let placeholder: Double = 0.3
            static let backgroundLight: Double = 0.1
        }
        
        // MARK: Line Spacing
        static let instructionLineSpacing: CGFloat = 4
        
        // MARK: Tag Padding
        enum TagPadding {
            static let horizontal: CGFloat = 10
            static let vertical: CGFloat = 4
        }
    }
    
    // MARK: - Strings
    enum Strings {
        // MARK: Navigation Titles
        static let categoriesTitle = String(localized: "Categories")
        
        // MARK: Section Titles
        static let ingredientsTitle = String(localized: "Ingredients")
        static let instructionsTitle = String(localized: "Instructions")
        static let videoTitle = String(localized: "Video")
        
        // MARK: Actions
        static let retryButton = String(localized: "Retry")
        static let watchOnYouTube = String(localized: "Watch on YouTube")
        
        // MARK: Loading State
        static let loadingMessage = String(localized: "Loading...")
        
        // MARK: Error Messages
        static let mealNotFound = String(localized: "Meal not found")
        
        // MARK: Accessibility
        enum Accessibility {
            static func mealPhoto(_ name: String) -> String {
                String(localized: "\(name) photo")
            }
            
            static func tag(_ name: String) -> String {
                String(localized: "Tag: \(name)")
            }
            
            static func ingredientRow(_ ingredient: String, _ measure: String) -> String {
                String(localized: "\(ingredient), \(measure)")
            }
            
            static let youtubeLink = String(localized: "Watch recipe video on YouTube")
        }
    }
    
    // MARK: - Icons
    enum Icons {
        // Error & Status
        static let error = "exclamationmark.triangle"
        
        // Categories & Tags
        static let tag = "tag"
        static let globe = "globe"
        
        // Media
        static let play = "play.circle.fill"
        static let externalLink = "arrow.up.right"
    }
    
    // MARK: - Network
    enum Network {
        static let baseURL = "https://www.themealdb.com/api/json/v1/1"
        
        enum Endpoints {
            static let categories = "/categories.php"
            static let filter = "/filter.php"
            static let lookup = "/lookup.php"
        }
        
        enum QueryParams {
            static let category = "c"
            static let id = "i"
        }
    }
    
    // MARK: - Colors
    enum Colors {
        static let youtubeRed = Color.red
    }
}
