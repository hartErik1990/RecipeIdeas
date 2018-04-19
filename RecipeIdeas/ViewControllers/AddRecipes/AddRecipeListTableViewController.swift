//
//  RecipeListTableViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/28/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import CoreData

final class AddRecipeListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UINavigationBarDelegate {
    
    // MARK: - Properties
    @IBOutlet weak private var addRecipesButton: UIBarButtonItem!
    @IBOutlet weak private var navigationItemTitle: UINavigationItem!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: UIImage(named: "Bread"))
        imageView.frame = self.tableView.frame
        self.tableView.backgroundView = imageView
        setupNavigationBlur()
        changeStatusBarColor()
        fetchedResultsController.delegate = self
        performFetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view = nil
    }
    
    func changeStatusBarColor() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupNavigationBlur() {
        let appTitleImage = UIImage(named: "TitleOfApp")
        let imageView = UIImageView(image: appTitleImage)
        navigationItemTitle.titleView = imageView
        guard let width = navigationController?.navigationBar.bounds.width, let height = navigationController?.navigationBar.bounds.height else { return }
        let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = CGRect(x: 0, y: -44, width: width, height: height * 2)
        print(visualEffectView.frame)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.addSubview(visualEffectView)
        self.navigationController?.navigationBar.sendSubview(toBack: visualEffectView)
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

extension AddRecipeListTableViewController {
    
    // MARK: - TableView Data Source
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
}

extension AddRecipeListTableViewController {
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}









