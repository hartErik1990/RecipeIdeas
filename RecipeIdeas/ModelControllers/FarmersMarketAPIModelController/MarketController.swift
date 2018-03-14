//
//  MarketController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation

final class MarketController {
    static let shared = MarketController()
    
    
    private let zipURL = "https://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch?zip="
    private let idURL = "https://search.ams.usda.gov/farmersmarkets/v1/data.svc/mktDetail?id="
    
    func fetchFarmersMarketData(with zipcode: String, completion: @escaping (FarmersMarketResults?, Error?) -> ()) {
        let urlString = zipURL + zipcode
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(nil, err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let results = try JSONDecoder().decode(FarmersMarketResults.self, from: data)
                completion(results, nil)
                
            } catch {
                completion(nil, error)
                print("A: \(error.localizedDescription)")
            }
            }.resume()
    }
    
    func getStaticData(with id: String, completion: @escaping (MarketDetails?, Error?) -> ()) {
        let urlString = idURL + id
        guard let url = URL(string:urlString ) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let err = error {
                completion(nil, err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let marketDetails = try JSONDecoder().decode(MarketDetails.self, from: data)
                completion(marketDetails, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
            }.resume()
    }
}
