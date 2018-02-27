//
//  RecipeTableViewCell.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/26/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    
    var hit: Hit? {
        didSet{
            updateView()
        }
    }
   
    var displayImage: UIImage? {
        didSet{
        updateView()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    
    func updateView() {
        guard let hit = hit else {return}
        //guard titleLabel.text == titleLabel.text else {return}
        
        if let displayImage = displayImage {
            displayImageView.image = displayImage
        } else {
            displayImageView.image = nil
        }
        titleLabel.text = hit.recipe.title
        displayImageView.addSubview(titleLabel)
    }
}
