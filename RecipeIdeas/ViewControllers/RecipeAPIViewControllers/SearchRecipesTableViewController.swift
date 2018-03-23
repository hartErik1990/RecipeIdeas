//
//  SearchRecipesTableViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/26/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

final class SearchRecipesTableViewController: UITableViewController, UISearchBarDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak private var searchBarTextField: UISearchBar!
    
    private var hits = [Hit]()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async { [unowned self] in
            self.searchBarTextField.backgroundImage = UIImage()
            guard let searchTerm = searchBar.text else { return }
            searchBar.resignFirstResponder()
            RecipeController.shared.fetchResults(with: searchTerm) { error in
                print(searchTerm)
                if let err = error {
                    NSLog("error with fetching MarketData \(err.localizedDescription) \(#function)"); return }
                self.tableView.reloadData()
                if RecipeController.shared.hits.count == 0 {
                    return self.noRecipeFoundAlert()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    // MARK: - turn the
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "Burger"))
        imageView.frame = self.tableView.frame
        self.tableView.backgroundView = imageView
        searchBarTextField.delegate = self
        searchBarTextField.backgroundImage = UIImage()
        searchBarTextField.placeholder = "Enter Ingredients here..."
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        // Hide the navigation bar for current view controller
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
  
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeController.shared.hits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? RecipeTableViewCell ?? RecipeTableViewCell()
        
        let hit = RecipeController.shared.hits[indexPath.row]
        
        RecipeController.shared.fetchImage(with: hit.recipe.image) { (image) in
            DispatchQueue.main.async { [unowned self] in
                cell.hit = hit
                if let currentIndexPath = self.tableView?.indexPath(for: cell), currentIndexPath == indexPath {
                    cell.displayImage = image
                    print("\(hit.recipe.image)")
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
    
    // MARK: - AlertController
    private func noRecipeFoundAlert() {
        let alert = UIAlertController(title: "No Results", message: "Could not find Recipe for what you are looking for please try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}














