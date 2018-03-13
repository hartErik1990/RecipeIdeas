//
//  FarmersMarketAPIModel.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation
//import CoreLocation

class FarmersMarketResults: Codable {
    var results: [MarketIdentifier]?
}

class MarketIdentifier: Codable {
    var id: String?
    var marketname: String?
}


class MarketDetails: Codable {
    var marketdetails: Details?
}

class Details: Codable {
    var Address: String?
    var GoogleLink: String?
    var Products: String?
    var Schedule: String?
}

