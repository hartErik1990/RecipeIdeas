//
//  RecipeListTableViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/28/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import CoreData

final class AddRecipeListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    private let fetchedResultsController: NSFetchedResultsController<AddRecipe> = {
        
        let fetchRequest: NSFetchRequest<AddRecipe> = AddRecipe.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error preformFetch failed :\(error.localizedDescription)")
        }
    }
    
    @IBOutlet weak private var addRecipesButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: UIImage(named: "Bread"))
        imageView.frame = self.tableView.frame
        self.tableView.backgroundView = imageView
        fetchedResultsController.delegate = self
        performFetch()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        var segue: UIStoryboardSegue?
//        if segue?.identifier == "toAddRecipeDetailVC" {
//            if let destination = segue?.destination as? AddRecipeDetailViewController {
//                print("YAYY it worked")
//            }
//        } else {
            print("NO it didnt work")
            self.view = nil
       // }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell", for: indexPath) as? AddRecipeTableViewCell ?? AddRecipeTableViewCell()
        
        let addedRecipe = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = addedRecipe.title
        guard let data = addedRecipe.imageData else { return UITableViewCell() }
        cell.addRecipeImageview?.image = UIImage(data: data)
        cell.addRecipeImageview.blackfade(cell.addRecipeImageview)
        cell.customLabel()
        cell.customImage()
       
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddRecipeDetailVC" {
            if let destination = segue.destination as? AddRecipeDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                let addedRecipe = fetchedResultsController.object(at: indexPath)
                destination.addedRecipe = addedRecipe
            }
        }
    }
   
}












