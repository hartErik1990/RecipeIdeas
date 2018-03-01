//
//  SearchRecipesTableViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/26/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class SearchRecipesTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBarTextField: UISearchBar!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {return}
        searchBar.resignFirstResponder()
        RecipeController.shared.fetchResults(with: searchTerm) {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return RecipeController.shared.hits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? RecipeTableViewCell ?? RecipeTableViewCell()

        let hit = RecipeController.shared.hits[indexPath.row]
        RecipeController.shared.fetchImage(with: hit.recipe.image) { (image) in
            DispatchQueue.main.async {
                cell.hit = hit
                if let currentIndexPath = self.tableView?.indexPath(for: cell), currentIndexPath == indexPath {
                    cell.displayImage = image
                } else {
                    NSLog("Error with getting image")
                    return
                }
            }
        }
        
        return cell
    }

    // MARK: - TableView Row Height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeVC" {
            if let destination = segue.destination as? RecipeViewController, let indexPath = tableView.indexPathForSelectedRow {
                let hit = RecipeController.shared.hits[indexPath.row]
                destination.hit = hit
                
            }
        }
    }
    

}














