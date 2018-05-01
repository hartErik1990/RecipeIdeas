
//
//  AddRecipeDetailCell.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/5/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//
import UIKit

final class  AddRecipeTableViewCell: UITableViewCell {
    
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
        titleLabel.zeroLineSpace()
        titleLabel.layer.cornerRadius = 12
        titleLabel.layer.borderWidth = 1.5
        //titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.layer.masksToBounds = true
    }
    
}

extension UILabel{
    public func zeroLineSpace(){
        let s = NSMutableAttributedString(string: self.text!)
        let style = NSMutableParagraphStyle()
        let lineHeight = (self.font.pointSize + 22) - self.font.ascender + self.font.capHeight
        let offset = self.font.capHeight - self.font.ascender
        let range = NSMakeRange(0, self.text!.count)
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.alignment = self.textAlignment
        s.addAttribute(.paragraphStyle, value: style, range: range)
        s.addAttribute(.baselineOffset, value: offset, range: range)
        self.attributedText = s
    }
}
