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
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientsLabel: UITextView!
    @IBOutlet weak var directionButtonLabel: UIButton!
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    func updateViews() {
        guard let hit = hit else {return}
        titleLabel.title = hit.recipe.title
        directionButtonLabel.titleLabel?.text = hit.recipe.url
        print(directionButtonLabel.titleLabel?.text ?? "")
        var formattedIngredientLines = ""
        for line in hit.recipe.ingredientLines {
            formattedIngredientLines += "• " + line + "\n"
        }
        ingredientsLabel.text = formattedIngredientLines
        RecipeController.shared.fetchImage(with: hit.recipe.image) { (image) in
            DispatchQueue.main.async { [weak self] in                self?.recipeImageView.image = image
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func directionsButtonTapped(_ sender: Any) {
        if let viewController = storyboard!.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
        viewController.urlString = hit?.recipe.url
        show(viewController, sender: self)
        }
    }
    
}

















