//
//  AddRecipeDetailCell.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/5/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

class AddRecipeDetailCell: UITableViewCell {

    var recipe: AddRecipe?
    
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var directionsTextView: UITextView!
    
    func updateDetailCellViews() {
        guard let recipe = recipe, var ingredient = ingredientTextField.text, var directions = directionsTextView.text, let recipeIngredients = recipe.ingredients, let recipeDirections = recipe.directions else {return}
        ingredient = recipeIngredients
        directions = recipeDirections
    }
}





