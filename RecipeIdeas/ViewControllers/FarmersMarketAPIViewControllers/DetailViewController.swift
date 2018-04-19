//
//  DetailsViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class DetailViewController: UIViewController, CLLocationManagerDelegate {
    
    private let clManager = CLLocationManager()
    
    weak var marketDetails: Details?
    weak var marketID: MarketIdentifier?
    
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak private var addressLabel: PaddingLabel!
    @IBOutlet weak private var scheduleLabel: PaddingLabel!
    @IBOutlet weak private var productsTextView: UITextView!
    @IBOutlet weak var titleOfFarmersMarketLabel: UILabel!
    @IBOutlet weak private var farmersMarketTitleLabel: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        clManager.delegate = self
        setupGetDirectionsButton()
        updateViews()
        view.backgroundColor = .white
        UINavigationBar.appearance().backgroundColor = view.backgroundColor
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    private func updateViews() {
        
        guard let newMarketName = marketID?.marketname else { return }
        let resultWithOutNumbers = newMarketName.index(newMarketName.startIndex, offsetBy: 4)
        let resultBackToString = newMarketName[resultWithOutNumbers...]
        titleOfFarmersMarketLabel.text = resultBackToString.components(separatedBy: "")[0]
        let titleOfImage = UIImage(named: "TitleOfApp")
        let imageView = UIImageView(image: titleOfImage)
        farmersMarketTitleLabel.titleView = imageView
        addressLabel.text = marketDetails?.Address
        scheduleLabel.text = marketDetails?.Schedule?
            .replacingOccurrences(of: ";<br> ", with: "")
            .replacingOccurrences(of: ";", with: ", ")
            .replacingOccurrences(of: "<br>", with: "")
        
        productsTextView.text = marketDetails?.Products?.replacingOccurrences(of: "; ", with: "\n")
    }
    
    func setupGetDirectionsButton() {
        getDirectionsButton.layer.cornerRadius = getDirectionsButton.frame.height/2
        getDirectionsButton.clipsToBounds = true
        getDirectionsButton.layer.borderWidth = 1
    }

    @IBAction private func addressButtonTapped(_ sender: Any) {
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        productsTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
}

