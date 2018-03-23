//
//  RecipeViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/26/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class RecipeViewController: UIViewController {
    
    // MARK: - Properties
    var hit: Hit?
    
    @IBOutlet weak private var recipeImageView: UIImageView!
    @IBOutlet weak private var titleOfIngredientsLabel: PaddingLabel!
    @IBOutlet weak private var ingredientsTextView: UITextView!
    @IBOutlet weak private var directionButtonLabel: CustomButton!
    @IBOutlet weak private var titleLabel: UINavigationItem!
    @IBOutlet weak private var blurEffect: CustomVisualEffect!
    
    private func updateViews() {
        guard let hit = hit else { return }
        titleLabel.title = hit.recipe.title
        directionButtonLabel.titleLabel?.text = hit.recipe.url
        var formattedIngredientLines = ""
        for line in hit.recipe.ingredientLines {
            formattedIngredientLines += "• " + line + "\n"
        }
        ingredientsTextView.text = formattedIngredientLines
        RecipeController.shared.fetchImage(with: hit.recipe.image) { (image) in
            DispatchQueue.main.async { [weak self] in
                self?.recipeImageView.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        custumDesign()
    }

    @IBAction private func directionsButtonTapped(_ sender: Any) {
        if let viewController = storyboard!.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            DispatchQueue.main.async { [weak self] in
                
                viewController.urlString = self?.hit?.recipe.url
                self?.show(viewController, sender: self)
            }
        }
    }
    private func custumDesign() {
        
        //customImageView
        recipeImageView.layer.cornerRadius = 12
        recipeImageView.backgroundColor = ColorScheme.shared.jungleMist
        recipeImageView.layer.borderWidth = 3
        recipeImageView.layer.borderColor = ColorScheme.shared.bunting.cgColor
        recipeImageView.layer.masksToBounds =  true
        
        //customLabel
        titleOfIngredientsLabel.layer.cornerRadius = 12
        titleOfIngredientsLabel.layer.borderWidth = 2
        titleOfIngredientsLabel.layer.borderColor = ColorScheme.shared.bunting.cgColor
        titleOfIngredientsLabel.layer.masksToBounds = true
        
        //customTextView
        ingredientsTextView.layer.cornerRadius =  12
        ingredientsTextView.layer.borderWidth = 3
        ingredientsTextView.layer.borderColor = ColorScheme.shared.bunting.cgColor
        ingredientsTextView.layer.masksToBounds = true
  
    }
}


















