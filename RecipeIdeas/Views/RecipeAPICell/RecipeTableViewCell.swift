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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customLabel(label: titleLabel)
        self.customLabel(label: ingredientsLabel)
        self.customImageView(imageView: displayImageView)
        blackfade()
    }
    
    @IBOutlet weak private var titleLabel: PaddingLabel!
    @IBOutlet weak private var displayImageView: UIImageView!
    @IBOutlet weak private var ingredientsLabel: PaddingLabel!
    
    private func updateView() {
//        DispatchQueue.main.async { [weak self] in
        
            guard let hit = self.hit else { return }
            guard let title = self.titleLabel, let ingredients = self.ingredientsLabel, var imageView = self.displayImageView else { return }
            if let displayImage = self.displayImage {
                displayImageView.image = displayImage
            } else {
                displayImageView.image = nil           }
            print(hit.recipe.title)
        
            title.text = hit.recipe.title
            self.ingredientsLabel.text = "Ingredients: \(hit.recipe.ingredients.count)"
            //self.displayImageView.addSubview(title)
        
        
    }
    
    func customLabel(label: PaddingLabel) {
        
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 2
        label.layer.borderColor = ColorScheme.shared.bunting.cgColor
        label.backgroundColor = ColorScheme.shared.jungleMist
        label.layer.masksToBounds = true
    }
    
    func customImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = ColorScheme.shared.bunting.cgColor
        imageView.layer.masksToBounds = true
        
    }
    func blackfade() {
        let view = UIView(frame: CGRect(x: displayImageView.frame.origin.x - 20, y: displayImageView.frame.origin.y, width: displayImageView.frame.size.width * 1.2, height: displayImageView.frame.size.height))
        
        let gradient = CAGradientLayer()
    
        gradient.frame = view.frame
        
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        
        gradient.locations = [0.0, 0.5, 1.0]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        displayImageView.addSubview(view)
        displayImageView.bringSubview(toFront: view)
    }

}













