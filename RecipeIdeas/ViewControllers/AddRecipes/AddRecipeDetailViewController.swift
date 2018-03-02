//
//  addRecipeDetailViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/28/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import Photos

final class AddRecipeDetailViewController: ShiftableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: - Properties
    var addedRecipe: AddRecipe?
    
    weak private var delegate: AddRecipeDetailViewControllerDelegate?
    
    @IBOutlet weak private var addRecipeImage: UIImageView!
    @IBOutlet weak private var titleTextView: UITextField!
    @IBOutlet weak private var ingredientsTextView: UITextView!
    @IBOutlet weak private var directionsTextView: UITextView!
    @IBOutlet weak private var addImageButton: UIButton!
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        directionsTextView.delegate = self
        updateViews()
    }
  
    private func updateViews() {
        guard let addedRecipe = addedRecipe else {return}
        
        titleTextView.text = addedRecipe.title
        directionsTextView.text = addedRecipe.directions
        //let ingredients = addedRecipe.ingredients
        //        guard var lines = ingredients?.components(separatedBy: CharacterSet.newlines) else { return }
        //        let bulletPoint = "O"
        //        for line in lines {
        //            if line.count == 0 {
        //                print(line)
        //                return
        //            } else {
        //
        //                lines.insert(bulletPoint, at: 0)
        //                print(lines)
        //                ingredientsTextView.text = bulletPoint + line
        //            }
        //        }
        ingredientsTextView.text = addedRecipe.ingredients
        addRecipeImage.image = UIImage(data: addedRecipe.imageData!)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - TextViewDelegate
    private func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    private func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let title = titleTextView.text, let ingredients = ingredientsTextView.text, let directions = directionsTextView.text, let imageData = addRecipeImage.image else {return}
        let image = Data(UIImageJPEGRepresentation(imageData, 0.9)!)
        //For UpdatingViews
        if let addedRecipe = addedRecipe {
            AddRecipeController.shared.updateRecipe(with: addedRecipe, title: title, ingredients: ingredients, directions: directions, imageData: image)
        } else {
            AddRecipeController.shared.addRecipe(withTitle: title, ingredients: ingredients, directions: directions, imageData: image)
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
            autoreleasepool {
                self.imagePicker.sourceType = .camera
                present((self.imagePicker), animated: true)
            }
        }
        
        func openPhotoLibrary(action: UIAlertAction) {
            autoreleasepool {
                self.imagePicker.sourceType = .photoLibrary
                present(self.imagePicker, animated: true)
            }
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









