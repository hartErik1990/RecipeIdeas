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
   
        updateViews()
    }
    
    weak var marketDetails: Details?
    weak var marketID: MarketIdentifier?
    
    @IBOutlet weak private var farmersMarketImageView: UIImageView!
    @IBOutlet weak private var addressLabel: PaddingLabel!
    @IBOutlet weak private var scheduleLabel: PaddingLabel!
    @IBOutlet weak private var productsTextView: UITextView!
    
    @IBOutlet weak private var titleForAddressLabel: PaddingLabel!
    @IBOutlet weak private var titleForScheduleLabel: PaddingLabel!
    @IBOutlet weak private var titleForProductsLabel: PaddingLabel!
    
    @IBOutlet weak private var farmersMarketTitleLabel: UINavigationItem!
    @IBOutlet weak private var addressVisualEffectView: CustomVisualEffect!
    @IBOutlet weak private var scheduleVisualEffectView: CustomVisualEffect!
    @IBOutlet weak private var productVisualEffectView: CustomVisualEffect!
    
    @IBOutlet weak private var addressTitleVisualEffectsLabel: CustomVisualEffect!
    @IBOutlet weak private var scheduleTitleVisualEffectsLabel: CustomVisualEffect!
    @IBOutlet weak private var productsTitleVisualEffectsLabel: CustomVisualEffect!
    
    private func updateViews() {
        
        customLargeLabel(label: addressLabel)
        customLargeLabel(label: scheduleLabel)
        customSmallLabel(label: titleForAddressLabel)
        customSmallLabel(label: titleForScheduleLabel)
        customSmallLabel(label: titleForProductsLabel)
        customDesign()
        guard let newMarketName = marketID?.marketname else { return }
        let resultWithOutNumbers = newMarketName.index(newMarketName.startIndex, offsetBy: 4)
        let resultBackToString = newMarketName[resultWithOutNumbers...]
        farmersMarketTitleLabel.title = resultBackToString.components(separatedBy: "")[0]
        
        addressLabel.text = marketDetails?.Address
        scheduleLabel.text = marketDetails?.Schedule?
            .replacingOccurrences(of: ";<br> ", with: "")
            .replacingOccurrences(of: ";", with: ", ")
            .replacingOccurrences(of: "<br>", with: "")
        
        productsTextView.text = marketDetails?.Products?.replacingOccurrences(of: "; ", with: "\n")
    }
    
    private func customLargeLabel(label: PaddingLabel) {
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 3
        label.layer.borderColor = ColorScheme.shared.bunting.cgColor
        //label.backgroundColor = ColorScheme.shared.slateGrey
        label.layer.masksToBounds = true
    }
    private func customSmallLabel(label: PaddingLabel) {
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 3
        label.layer.borderColor = ColorScheme.shared.bunting.cgColor
        label.backgroundColor = UIColor.clear
        label.layer.masksToBounds = true
    }
    private func customDesign() {

        //  customTextView()
        productsTextView.layer.cornerRadius = 12
        productsTextView.layer.borderWidth = 2.5
        productsTextView.layer.borderColor = ColorScheme.shared.bunting.cgColor
        productsTextView.layer.masksToBounds = true
    }
}

