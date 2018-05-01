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
    
    let marketDetail: Details
    let marketID: MarketIdentifier
    var latitude: Double?
    var longitude: Double?
    var title: String?
    
    var coordinate: CLLocationCoordinate2D
    // Make sure to give the MarketIdentifier a default initializer becuase you wont always need it
    init(marketDetails: Details, marketID: MarketIdentifier = MarketIdentifier(), latitude: Double = 0.0, longitude: Double = 0.0) {
        self.marketDetail = marketDetails
        self.marketID = marketID
        self.latitude = latitude
        self.longitude = longitude
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
