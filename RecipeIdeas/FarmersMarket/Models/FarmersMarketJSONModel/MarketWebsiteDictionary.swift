//
//  WebsiteJSONDictionary.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 4/23/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation

struct MarketWebsiteDictionary: Codable {
    let results: [Result]
}

struct Result: Codable {
    let fmid: Int
    var marketName, website, facebook: String
    
    enum CodingKeys: String, CodingKey {
        case fmid = "FMID"
        case marketName = "MarketName"
        case website = "Website"
        case facebook = "Facebook"
    }
}
