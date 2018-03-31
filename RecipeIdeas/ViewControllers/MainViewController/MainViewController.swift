//
//  MainViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/9/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak private var visualEffectLabel: CustomVisualEffect!
    
    @IBOutlet weak private var quoteLabel: PaddingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customLabel()
        randomQuote()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
        // Hide the navigation bar for current view controller
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false
        self.view = nil 
    }
 
    private func randomQuote() {
        let name = QuotesFromCooks.init().qoutes[Int(arc4random_uniform(UInt32(QuotesFromCooks.init().qoutes.count)))]
        quoteLabel.text = name
        print(name)
    }

    private func customLabel() {
        let color = ColorScheme()
        quoteLabel.layer.cornerRadius = 12
        quoteLabel.layer.borderColor = color.bunting.cgColor
        quoteLabel.layer.borderWidth = 2
    }
}


