//
//  MarketController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 3/11/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation

final class MarketController {
    
    // MARK: - Properties
    static let shared = MarketController()
    
    private let zipURL = "https://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch?zip="
    private let idURL = "https://search.ams.usda.gov/farmersmarkets/v1/data.svc/mktDetail?id="
    
    func fetchFarmersMarketData(with zipcode: String, completion: @escaping (FarmersMarketResults?, Error?) -> ()) {
        let urlString = zipURL + zipcode
        guard let url = URL(string: urlString) else { return }
        let datatask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let err = error {
                NSLog(err.localizedDescription)
                completion(nil, err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let results = try JSONDecoder().decode(FarmersMarketResults.self, from: data)
                completion(results, nil)
                
            } catch {
                completion(nil, error)
                NSLog("Error with URLSession in fetchFarmersMarketData \(error.localizedDescription)")
            }
        }
        datatask.resume()
    }
    
    func getLocation(With lat: Double, and long: Double, completion: @escaping (FarmersMarketResults?, Error?) -> Void) {
        let urlString = "https://search.ams.usda.gov/farmersmarkets/v1/data.svc/locSearch?lat=\(lat)&lng=\(long)"
        guard let url = URL(string: urlString) else { return }
        print(urlString)
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let err = error {
                NSLog(err.localizedDescription)
                completion(nil, err)
                return
            }
            guard let data = data else { return }
            
            do {
                let results = try JSONDecoder().decode(FarmersMarketResults.self, from: data)
                completion(results, nil)
                
            } catch {
                completion(nil, error)
                NSLog("Error with URLSession in getLocation \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    func fetchIdFromFarmersMarketResults(with id: String, completion: @escaping (MarketDetails?, Error?) -> ()) {
        let urlString = idURL + id
        print(urlString)
        guard let url = URL(string:urlString ) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let err = error {
                completion(nil, err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let marketDetails = try JSONDecoder().decode(MarketDetails.self, from: data)
                completion(marketDetails, nil)
            } catch {
                NSLog("Error with URLSession in getLocation\(error.localizedDescription)")
                completion(nil, error)
            }
        }
        dataTask.resume()
    }
}
