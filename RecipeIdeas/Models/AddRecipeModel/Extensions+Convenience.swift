//
//  Extensions+Convenience.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/28/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation
import CoreData

extension AddRecipe {
    @discardableResult convenience init(title: String, ingredients: String, directions: String, imageData: Data, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.title = title
        self.ingredients = ingredients
        self.directions = directions
        self.imageData = imageData
    }
}
