//
//  RecipeController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/26/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation

class RecipeController {
    
    static let shared = RecipeController()
    
    let baseURL = URL(string: "https://api.edamam.com/search")!
    
}
