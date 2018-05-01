//
//  CustomImage.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/14/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func blackfade(_ imageView: UIImageView) {
        let view = UIView(frame: CGRect(x: imageView.frame.origin.x - 8, y: imageView.frame.origin.y, width: UIScreen.main.bounds.width, height: imageView.frame.size.height))
        print(view)
        let gradient = CAGradientLayer()
        
        gradient.frame = view.frame
        
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        
        gradient.locations = [0.0, 0.5, 1.0]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        imageView.addSubview(view)
        imageView.bringSubview(toFront: view)
    }
}
