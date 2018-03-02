//
//  AddRecipeTableViewCell.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/1/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

class AddRecipeTableViewCell: UITableViewCell {
   
    // MARK: - Properties
    var recipe: AddRecipe? {
        didSet {
            updateViews()
        }
    }
    
    var addRecipeImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var addRecipeImageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func updateViews() {
        guard let recipe = recipe else {return}
        
        if let addRecipeImage = addRecipeImage {
            addRecipeImageview.image = addRecipeImage
        } else {
            addRecipeImageview.image = nil
        }
        titleLabel.text = recipe.title
        //addRecipeImageview.addSubview(titleLabel)
    }
}
