//
//  RecipeViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/26/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    // MARK: - Properties
    var hit: Hit?
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var directionButtonLabel: UIButton!
    @IBOutlet weak var titleLabel: UINavigationItem!
    
//    func updateViews(recipe: Recipe, ingredients: Ingredient) {
//        ingredientsLabel.text = ingredients.text
//        titleLabel.title = recipe.title
//        directionButtonLabel.titleLabel?.text = recipe.url
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

















