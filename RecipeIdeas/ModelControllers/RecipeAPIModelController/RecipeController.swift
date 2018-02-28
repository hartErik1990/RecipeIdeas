//
//  RecipeController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/26/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

class RecipeController {
    
    // MARK: - Properties
    static let shared = RecipeController()
    
    private let baseURL = URL(string: "https://api.edamam.com/search")!
    
    private let appID = "8983588f"
    
    private let appKey = "a8a1b901fb9f1c1c426dc685606e2043"
    
    var hits = [Hit]()
    
    func fetchResults(with searchTerm: String, completion: @escaping () -> Void) {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        
        components?.queryItems = [URLQueryItem(name: JSONDictionary.CodingKeys.q.stringValue, value: searchTerm.replacingOccurrences(of: " ", with: "+")),
                                  URLQueryItem(name: "app_id", value: appID),
                                  URLQueryItem(name: "app_key", value: appKey),
                                  URLQueryItem(name: JSONDictionary.CodingKeys.from.rawValue, value: "\(0)"),
                                  URLQueryItem(name: JSONDictionary.CodingKeys.to.rawValue, value: "\(50)")]
        guard let url = components?.url else { completion() ; return}
        print("\(url)")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            do {
                if let error = error {
                    NSLog("Error with perfoming the Network Request \(error.localizedDescription) \(#function)")
                    completion() ; return
                }
                guard let data = data else { completion(); return}
                let jsonDictionary = try JSONDecoder().decode(JSONDictionary.self, from: data)
                let hits = jsonDictionary.hits
                self.hits = hits
                completion()
            } catch {
                NSLog("Error with Decoding JSON \(error.localizedDescription) \(#function)")
                completion(); return
            }
        }.resume()
    }
    
    func fetchImage(with urlString: String, completion: @escaping(UIImage?) -> Void) {
        
        guard let url = URL(string: urlString) else {completion(nil); return}
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error with converting URL to data \(error.localizedDescription) \(#function)")
                completion(nil); return
            }
            guard let data = data else {completion(nil); return}
            let image = UIImage(data: data)
            completion(image)
        }
        dataTask.resume()
    }
    
}
















