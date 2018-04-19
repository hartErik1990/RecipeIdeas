//
//  FarmersMarketAPIModel.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation

// Head of the JSON Dictionary
final class FarmersMarketResults: Codable {
    var results: [MarketIdentifier]?
}

// Gets the MarketID
final class MarketIdentifier: Codable {
    var id: String?
    var marketname: String?
}

// Calls the Market Details
final class MarketDetails: Codable {
    var marketdetails: Details?
}

// Gets the details from the farmers markets
final class Details: Codable {
    var Address: String?
    var GoogleLink: String?
    var Products: String?
    var Schedule: String?
}

