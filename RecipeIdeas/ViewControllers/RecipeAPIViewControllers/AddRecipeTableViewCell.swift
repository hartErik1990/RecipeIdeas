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
//    private var recipe: AddRecipe? {
//        didSet {
//            updateViews()
//        }
//    }
//
//    private var addRecipeImage: UIImage? {
//        didSet {
//            updateViews()
//        }
//    }
    
    @IBOutlet weak var addRecipeImageview: UIImageView!
    @IBOutlet weak var titleLabel: PaddingLabel!
    
//    func updateViews() {
//        guard let recipe = recipe else { return }
//        
//        if let addRecipeImage = addRecipeImage {
//            addRecipeImageview.image = addRecipeImage
//        } else {
//            addRecipeImageview.image = nil
//        }
//        titleLabel.text = recipe.title
//        customImage()
//        customLabel()
//        addRecipeImageview.addSubview(titleLabel)
//    }
    
    func customImage() {
        addRecipeImageview.layer.cornerRadius = 12
        addRecipeImageview.layer.borderWidth = 3
        addRecipeImageview.layer.borderColor = ColorScheme.shared.bunting.cgColor
        addRecipeImageview.layer.masksToBounds = true
    }
    func customLabel() {
        titleLabel.layer.cornerRadius = 12
        titleLabel.layer.borderWidth = 1.5
        titleLabel.layer.borderColor = ColorScheme.shared.bunting.cgColor
        titleLabel.backgroundColor = ColorScheme.shared.jungleMist
        titleLabel.layer.masksToBounds = true
    }
    
}











