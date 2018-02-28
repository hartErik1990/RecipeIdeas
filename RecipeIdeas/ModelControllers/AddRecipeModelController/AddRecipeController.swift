//
//  AddRecipeController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/28/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

class AddRecipeController {
    
    // MARK: - Properties
    static let shared = AddRecipeController()
    
    var addRecipes = [AddRecipe]()

    // MARK: - CRUD
    func addRecipe(withTitle title: String, ingredients: String, directions: String) {
        AddRecipe(title: title, ingredients: ingredients, directions: directions)
        saveToPersistentStore()
    }
    func delete(recipe: AddRecipe) {
        CoreDataStack.context.delete(recipe)
        saveToPersistentStore()
    }
    func updateRecipe(with recipe: AddRecipe, title: String, ingredients: String, directions: String) {
        recipe.title = title
        recipe.ingredients = ingredients
        recipe.directions = directions
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do { try CoreDataStack.context.save()
        } catch {
            NSLog("Error saving failed with error of \(error.localizedDescription)")
        }
    }
    
}
