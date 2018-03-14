//
//  DetailsViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(marketDetails?.Address)
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    var marketDetails: Details?
    
    @IBOutlet weak private var farmersMarketImageView: UIImageView!
    @IBOutlet weak private var addressLabel: PaddingLabel!
    @IBOutlet weak private var scheduleLabel: PaddingLabel!
    @IBOutlet weak private var productsTextView: UITextView!
    
    @IBOutlet weak private var titleForAddressLabel: PaddingLabel!
    @IBOutlet weak private var titleForScheduleLabel: PaddingLabel!
    @IBOutlet weak private var titleForProductsLabel: PaddingLabel!
    
    
    private func updateViews() {
        
        custumLabel(label: addressLabel)
        custumLabel(label: scheduleLabel)
        custumLabel(label: titleForAddressLabel)
        custumLabel(label: titleForScheduleLabel)
        custumLabel(label: titleForProductsLabel)
        customDesign()
        addressLabel.text = marketDetails?.Address
        scheduleLabel.text = marketDetails?.Schedule?
            .replacingOccurrences(of: ";<br> ", with: "")
            .replacingOccurrences(of: ";", with: ", ")
            .replacingOccurrences(of: "<br>", with: "")
        
        productsTextView.text = marketDetails?.Products?.replacingOccurrences(of: "; ", with: "\n")
    }
    
    private func custumLabel(label: PaddingLabel) {
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 3
        label.layer.borderColor = ColorScheme.shared.bunting.cgColor
        label.backgroundColor = ColorScheme.shared.slateGrey
        label.layer.masksToBounds = true
    }
    private func customDesign() {
        //customImage()
        farmersMarketImageView.layer.cornerRadius = 12
        farmersMarketImageView.layer.borderWidth = 3
        farmersMarketImageView.layer.borderColor = ColorScheme.shared.bunting.cgColor
        farmersMarketImageView.layer.masksToBounds = true
        
        //  customTextView()
        productsTextView.layer.cornerRadius = 12
        productsTextView.layer.borderWidth = 1
        productsTextView.layer.borderColor = ColorScheme.shared.bunting.cgColor
        productsTextView.layer.masksToBounds = true
    }
}

