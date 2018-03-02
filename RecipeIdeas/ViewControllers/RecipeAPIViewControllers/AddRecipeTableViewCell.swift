//
//  AddRecipeTableViewCell.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/1/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class AddRecipeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private var recipe: AddRecipe? {
        didSet {
            updateViews()
        }
    }
    
    private var addRecipeImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var addRecipeImageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private func updateViews() {
        guard let recipe = recipe else {return}
        
        if let addRecipeImage = addRecipeImage {
            addRecipeImageview.image = addRecipeImage
        } else {
            addRecipeImageview.image = nil
        }
        titleLabel.text = recipe.title
    }
}
