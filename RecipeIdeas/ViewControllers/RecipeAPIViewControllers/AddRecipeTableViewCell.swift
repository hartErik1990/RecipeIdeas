//
//  AddRecipeTableViewCell.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/1/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class AddRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var addRecipeImageview: UIImageView!
    @IBOutlet weak var titleLabel: PaddingLabel!
    @IBOutlet weak var titleVisualEffectsLabel: CustomVisualEffect!

    func customImage() {
        addRecipeImageview.layer.cornerRadius = 12
        addRecipeImageview.layer.borderWidth = 3
        addRecipeImageview.layer.borderColor = ColorScheme.shared.bunting.cgColor
        addRecipeImageview.layer.masksToBounds = true
    }
    func customLabel() {
        titleLabel.layer.cornerRadius = 12
        titleLabel.layer.borderWidth = 1.5
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.layer.masksToBounds = true
    }
    
}











