//
//  CoreDataStack.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/28/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let RecipeIdeas = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
        let container = NSPersistentContainer(name: RecipeIdeas)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error): \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return container.viewContext }
}


