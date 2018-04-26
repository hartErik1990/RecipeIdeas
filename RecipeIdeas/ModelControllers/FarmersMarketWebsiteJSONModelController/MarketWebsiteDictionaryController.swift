//
//  MarketWebsiteDictionaryController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 4/23/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation

class MarketWebsiteDictionaryController {
    
    static let shared = MarketWebsiteDictionaryController()
    var property: String?
    
    func fetchMarketIDFromLocalFile(with id: String) {
        let path = Bundle.main.path(forResource: "websitesAndIDs", ofType: ".json")
        let url = URL(fileURLWithPath: path!)
        
        do {
            let data = try Data(contentsOf: url)
            let websiteAndIDs = try JSONDecoder().decode(MarketWebsiteDictionary.self, from: data)
            let results = websiteAndIDs.results
            
            for result in results {
                if "\(result.fmid)" == id {
                    if result.website == "" {
                        property = "No Result"
                        print(property)
                    } else {
                        property = result.website
                        print(property)
                    }
                }
            }
            } catch {
                NSLog("Error with parsing JSON from local file \(error.localizedDescription, #function)")
        }
        
    }
}
