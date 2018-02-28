//
//  Recipe.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/26/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation

// MARK: - First level
struct JSONDictionary: Decodable {
    let q: String
    let from: Int
    let to: Int
    let hits: [Hit]
    
    enum CodingKeys: String, CodingKey {
        case q = "q"
        case from = "from"
        case to = "to"
        case hits = "hits"
    }
}
// MARK: - Second level
struct Hit: Decodable {
    let recipe: Recipe
    let bookmarked: Bool
    let bought: Bool
    
    enum CodingKeys: String, CodingKey {
        case recipe = "recipe"
        case bookmarked = "bookmarked"
        case bought = "bought"
    }
}
// MARK: - Third level
struct Recipe: Decodable {
    let title: String
    let image: String
    let source: String
    let url: String
    let ingredients: [Ingredient]
    let ingredientLines: [String]
    
    enum CodingKeys: String, CodingKey {
        case title = "label"
        case image = "image"
        case source = "source"
        case url = "url"
        case ingredients = "ingredients"
        case ingredientLines = "ingredientLines"
    
    }
}
// MARK: - Forth level
struct Ingredient: Decodable {
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
    }
}
