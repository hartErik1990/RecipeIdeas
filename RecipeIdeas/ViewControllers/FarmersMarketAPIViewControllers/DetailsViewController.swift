//
//  DetailsViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(marketDetails?.Address)
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    var marketDetails: Details?
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var productsTextView: UITextView!
    func updateViews() {
        
        addressLabel.text = marketDetails?.Address
        scheduleLabel.text = marketDetails?.Schedule?
            .replacingOccurrences(of: ";<br> ", with: "")
            .replacingOccurrences(of: ";", with: ", ")
            .replacingOccurrences(of: "<br>", with: "")
        
        productsTextView.text = marketDetails?.Products?.replacingOccurrences(of: "; ", with: "\n")
    }
    
}

