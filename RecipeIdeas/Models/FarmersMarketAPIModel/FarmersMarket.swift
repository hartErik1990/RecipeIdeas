//
//  FarmersMarketAPIModel.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation

// Head of the JSON Dictionary
final class FarmersMarketResults: Decodable {

    var results: [MarketIdentifier]?
}

// Gets the MarketID
struct MarketIdentifier: Decodable, Equatable {
    var id: String?
    var marketname: String?
}

// Calls the Market Details
struct MarketDetails: Decodable {
    var marketdetails: Details?
}

// Gets the details from the farmers markets
struct Details: Decodable {
    let address: String
    let googleLink: String
    var products: String?
    var schedule: String?
    
    enum CodingKeys: String, CodingKey {
        case address = "Address"
        case googleLink = "GoogleLink"
        case products = "Products"
        case schedule = "Schedule"
    }
}

