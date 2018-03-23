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
    
    weak var displayImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customLabel(label: titleLabel)
        self.customLabel(label: ingredientsLabel)
        self.customImageView(imageView: displayImageView)
        displayImageView.blackfade(displayImageView)

    }
    
    @IBOutlet weak private var titleLabel: PaddingLabel!
    @IBOutlet weak private var displayImageView: UIImageView!
    @IBOutlet weak private var ingredientsLabel: PaddingLabel!
    
    @IBOutlet weak private var titleVisualEffectsLabel: CustomVisualEffect!
    @IBOutlet weak private var ingredientsVisualEffectsLabel: CustomVisualEffect!
   
    private func updateView() {
        
        guard let hit = self.hit else { return }
        guard let title = self.titleLabel, let ingredients = self.ingredientsLabel, var imageView = self.displayImageView else { return }
        if let displayImage = self.displayImage {
            imageView.image = displayImage
        } else {
            imageView.image = nil           }
        print(hit.recipe.title)
        
        title.text = hit.recipe.title
        self.ingredientsLabel.text = "Ingredients: \(hit.recipe.ingredients.count)"
        
    }
    
    private func customLabel(label: PaddingLabel) {
        
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 2
        label.layer.borderColor = ColorScheme.shared.bunting.cgColor
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.layer.masksToBounds = true
    }
    
    private func customImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = ColorScheme.shared.bunting.cgColor
        imageView.layer.masksToBounds = true
        
    }
}













