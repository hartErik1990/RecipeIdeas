//
//  MarketAnnotation.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import MapKit

final class MarketAnnotation: NSObject, MKAnnotation {
    
    var marketDetail: Details
    var marketID: MarketIdentifier
    var lat: Double?
    var lon: Double?
    var title: String?
    
    var coordinate: CLLocationCoordinate2D
    init(marketDetails: Details, marketID: MarketIdentifier = MarketIdentifier(), lat: Double = 0.0, lon: Double = 0.0) {
        self.marketDetail = marketDetails
        self.marketID = marketID
        self.lat = lat
        self.lon = lon
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
}
