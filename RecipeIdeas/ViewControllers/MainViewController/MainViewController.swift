//
//  MainViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/9/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var quoteButton: CustomButton!
    
    @IBAction func randomQuoteButtonTapped(_ sender: Any) {
        quoteLabel.text = ""
        viewDidLoad()
        UIView.transition(with: quoteLabel, duration: 1, options: [.transitionCrossDissolve], animations: nil, completion: nil)
       
    }
    
    @IBOutlet weak var quoteLabel: PaddingLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customLabel()
        randomQuote()
        
    }
 
    func randomQuote() {
        let name = QuotesFromCooks.init().qoutes[Int(arc4random_uniform(UInt32(QuotesFromCooks.init().qoutes.count)))]
        quoteLabel.text = name
        print(name)
    }
   
    
}

extension MainViewController {
    func customLabel() {
        let color = ColorScheme()
        quoteLabel.layer.cornerRadius = 12
        quoteLabel.layer.borderColor = color.bunting.cgColor
        quoteLabel.layer.borderWidth = 2
            }
}

class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}

