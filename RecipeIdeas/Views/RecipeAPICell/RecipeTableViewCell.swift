//
//  RecipeTableViewCell.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/26/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var hit: Hit? {
        didSet {
            updateView()
        }
    }
    
    var displayImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var displayImageView: UIImageView!
    @IBOutlet weak private var ingredientsLabel: UILabel!
    
    private func updateView() {
        guard let hit = hit else { return }
        
        if let displayImage = displayImage {
            displayImageView.image = displayImage
        } else {
            displayImageView.image = nil
        }
        print(hit.recipe.title)
        titleLabel.text = hit.recipe.title
        ingredientsLabel.text = "Ingredients: \(hit.recipe.ingredients.count)"
        displayImageView.addSubview(titleLabel)
    }
}
