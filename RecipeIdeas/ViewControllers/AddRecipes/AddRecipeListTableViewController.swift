//
//  RecipeListTableViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/28/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    let fetchedResultsController: NSFetchedResultsController<AddRecipe> = {
        
        let fetchRequest: NSFetchRequest<AddRecipe> = AddRecipe.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error preformFetch failed :\(error.localizedDescription)")
        }
    }
    
    @IBOutlet weak var addRecipesButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        
        performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell", for: indexPath) as? AddRecipeTableViewCell ?? AddRecipeTableViewCell()

        let addedRecipe = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = addedRecipe.title
        guard let data =  addedRecipe.imageData else {return UITableViewCell()}
        cell.addRecipeImageview?.image = UIImage(data: data)
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let addedRecipe = fetchedResultsController.object(at: indexPath)
            AddRecipeController.shared.delete(recipe: addedRecipe)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddRecipeDetailVC" {
            if let destination = segue.destination as? AddRecipeDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                let addedRecipe = fetchedResultsController.object(at: indexPath)
                destination.addedRecipe = addedRecipe
            }
        }
    }
    

}












