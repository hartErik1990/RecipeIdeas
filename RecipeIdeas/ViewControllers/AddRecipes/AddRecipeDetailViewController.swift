//
//  addRecipeDetailViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/28/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import Photos

class AddRecipeDetailViewController: ShiftableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // MARK: - Properties
    var addedRecipe: AddRecipe?
    
    weak var delegate: AddRecipeDetailViewControllerDelegate?
    
    @IBOutlet weak var addRecipeImage: UIImageView!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var directionsTextView: UITextView!
    @IBOutlet weak var addImageButton: UIButton!
  
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        directionsTextView.delegate = self

    }
 
    func updateViews() {
       // guard let addedRecipe = addedRecipe else {return}
        
        titleTextView.text = addedRecipe?.title
        directionsTextView.text = addedRecipe?.directions
        ingredientsTextView.text =  addedRecipe?.ingredients
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - TextViewDelegate
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextView.text, let ingredients = ingredientsTextView.text, let directions = directionsTextView.text else {return}
        //For UpdatingViews
        if let addedRecipe = addedRecipe {
            AddRecipeController.shared.updateRecipe(with: addedRecipe, title: title, ingredients: ingredients, directions: directions)
        } else {
            AddRecipeController.shared.addRecipe(withTitle: title, ingredients: ingredients, directions: directions)
        }
        navigationController?.popViewController(animated: true)
    }
    
    //ImagePicker
    @IBAction func addImageButtonTapped(_ sender: Any) {
        
        func openCamera(action: UIAlertAction){
            guard UIImagePickerController.isSourceTypeAvailable(.camera) == true else {
                print("No camera available")
                return
            }
            self.imagePicker.sourceType = .camera
            present(self.imagePicker, animated: true)
        }
        
        func openPhotoLibrary(action: UIAlertAction) {
            self.imagePicker.sourceType = .photoLibrary
            present(self.imagePicker, animated: true)
        }
        let alertController = UIAlertController(title: "Select an image source", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Take a picture", style: .default, handler: openCamera))
        alertController.addAction(UIAlertAction(title: "Choose from library", style: .default, handler: openPhotoLibrary))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            delegate?.AddRecipeDetailViewControllerSelected(image)
            addImageButton.setTitle("", for: UIControlState())
            addRecipeImage.image = image
        }
    }

}

protocol AddRecipeDetailViewControllerDelegate: class {
    
    func AddRecipeDetailViewControllerSelected(_ image: UIImage)
}









