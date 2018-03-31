//
//  DetailsViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

final class DetailViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clManager.delegate = self
        updateViews()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(navigationController?.viewControllers.count)
        
    }
    let clManager = CLLocationManager()
    
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
    @IBOutlet weak var addressButton: UIButton!
    
    
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
    
    // segue to the apple map view
    @IBAction func addressButtonColorChanged(_ sender: Any) {
        addressLabel.textColor = UIColor.blue
    }
    
    @IBAction func addressButtonTapped(_ sender: Any) {
        addressLabel.textColor = UIColor.black
        
        guard let marketResult = marketDetails?.GoogleLink?.replacingOccurrences( of:"[^0.0-9, -]", with: "", options: .regularExpression) else { return }
        let newResult = marketResult.replacingOccurrences(of: "220-", with: " -")
        let indexStartOfText = newResult.index(newResult.startIndex, offsetBy: 2)
        
        let substring1 = newResult[indexStartOfText...]
        let indexEndOfText = substring1.index(substring1.endIndex, offsetBy: -6)
        let substring2 = substring1[..<indexEndOfText]
        
        let stringedArray = substring2.components(separatedBy: " ")
        guard let lat = Double(stringedArray[0]) else { return }
        guard let lon = Double(stringedArray[1]) else { return }

        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(lat, lon)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = marketDetails?.Address
        mapItem.openInMaps(launchOptions: options)
       
    }
    
}

