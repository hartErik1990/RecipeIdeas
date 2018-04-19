//
//  addRecipeDetailViewController.swift
//  RecipeIdeas
//
//  Created by Erik HARTLEY on 2/28/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import Photos

protocol AddRecipeDetailViewControllerDelegate: class {
    func AddRecipeDetailViewControllerSelected(_ image: UIImage)
}

final class AddRecipeDetailViewController: ShiftableViewController,  UINavigationControllerDelegate {
    
    // MARK: - Properties
    weak var addedRecipe: AddRecipe?
    
    weak private var delegate: AddRecipeDetailViewControllerDelegate?
    
    @IBOutlet weak private var addRecipeImage: UIImageView!
    @IBOutlet weak private var titleTextView: PlaceholderTextView!
    @IBOutlet weak private var ingredientsTextView: PlaceholderTextView!
    @IBOutlet weak private var directionsTextView: PlaceholderTextView!
    @IBOutlet weak private var addImageButton: UIButton!
    @IBOutlet weak private var navigationItemTitle: UINavigationItem!
    private let imagePicker = UIImagePickerController()
    private var editButton = UIBarButtonItem()
    private var saveButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        titleTextView.delegate = self
        ingredientsTextView.delegate = self
        directionsTextView.delegate = self
        customImageAndNavigationTitle()
        customTextView(textViews: [titleTextView, ingredientsTextView, directionsTextView])
        updateViews()
        editButtonTapped()
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .white
        setUpRightBarButtonItems()
    }
    
    // sets up logic for Edit and Save & placeholderText behaves correctly
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        placeholderTextClearsWhenTextIsPresent()
        if addedRecipe != nil {
            setUserInteractionToFalse(true)
        }
    }
    
    private func updateViews() {
        guard let addedRecipe = addedRecipe else { return }
        
        titleTextView.text = addedRecipe.title
        directionsTextView.text = addedRecipe.directions
        ingredientsTextView.text = addedRecipe.ingredients
        addRecipeImage.image = UIImage(data: addedRecipe.imageData!)
    }
    
    // Makes sure the placeholder text is set to empty when it should be
    func placeholderTextClearsWhenTextIsPresent() {
        if !titleTextView.text.isEmpty {
            titleTextView.placeholder = ""
        }
        if !ingredientsTextView.text.isEmpty {
            ingredientsTextView.placeholder = ""
        }
        if !directionsTextView.text.isEmpty {
            directionsTextView.placeholder = ""
        }
    }
    
    private func customImageAndNavigationTitle() {
        // Navigation Title
        let appTitleImage = UIImage(named: "TitleOfApp")
        let imageView = UIImageView(image: appTitleImage)
        navigationItemTitle.titleView = imageView
        // CustomImage()
        addRecipeImage.layer.cornerRadius = 12
        addRecipeImage.layer.borderWidth = 0.5
        addRecipeImage.layer.borderColor = ColorScheme.shared.bunting.cgColor
        addRecipeImage.layer.masksToBounds = true
    }
    
    private func customTextView(textViews: [UITextView]) {
        for textView in textViews {
            textView.layer.cornerRadius = 12
            textView.layer.borderWidth = 0.4
            textView.layer.borderColor = ColorScheme.shared.bunting.cgColor
            textView.layer.masksToBounds = true
        }
    }
    
    // Saving to CoreData
    @objc private func saveButtonTapped() {
        
        guard let title = titleTextView.text, let ingredients = ingredientsTextView.text, let directions = directionsTextView.text, let imageData = addRecipeImage.image else { return }
        func oneWhiteSpace(input: String) -> String {
            return input.replacingOccurrences(of: " +", with: " ",
                                              options: .regularExpression, range: nil)
        }
        let oneSpaceTitle = oneWhiteSpace(input: title)
        // Checking to see if there is any White Space in the title
        if title == "" || oneSpaceTitle == " " {
            noRecipeTitleAlert()
        } else {
            let image = Data(UIImageJPEGRepresentation(imageData, 0.5)!)
            //For UpdatingViews
            if let addedRecipe = addedRecipe {
                AddRecipeController.shared.updateRecipe(with: addedRecipe, title: title, ingredients: ingredients, directions: directions, imageData: image)
            } else {
                AddRecipeController.shared.addRecipe(withTitle: title, ingredients: ingredients, directions: directions, imageData: image)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    // Setting up the Right Bar Button Item
    private func setUpRightBarButtonItems() {
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    // Disables user interaction if they dont want to edit their recipe
    private func setUserInteractionToFalse(_ bool: Bool) {
        if bool == true {
            navigationItem.rightBarButtonItem = editButton
            if !titleTextView.text.isEmpty {
                titleTextView.isEditable = false
            }
            if !ingredientsTextView.text.isEmpty {
                ingredientsTextView.isEditable = false
            }
            if !directionsTextView.text.isEmpty {
                directionsTextView.isEditable = false
            }
            
        } else {
            titleTextView.isUserInteractionEnabled = true
        }
    }
    @objc private func editButtonTapped() {
        navigationItem.rightBarButtonItem = saveButton
        titleTextView.isEditable = true
        ingredientsTextView.isEditable = true
        directionsTextView.isEditable = true
    }
    
    // ImagePicker Button Tapped
    @IBAction private func addImageButtonTapped(_ sender: Any) {
        
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
    
    //Custom Alert to prevent people from adding an empty title
    private func noRecipeTitleAlert() {
        let alert = UIAlertController(title: "Please Enter a Title", message: "so you can organize your recipes better", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let shareVC = UIActivityViewController(activityItems: ["Title:", titleTextView.text, addRecipeImage.image, "Ingredients:", ingredientsTextView.text, "Directions:", directionsTextView.text], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        self.present(shareVC, animated: true, completion: nil)
    }
}

extension AddRecipeDetailViewController: UIImagePickerControllerDelegate {
    
    // ImagePicker delegate Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            delegate?.AddRecipeDetailViewControllerSelected(image)
            addImageButton.setTitle("", for: UIControlState())
            addRecipeImage.image = image
        }
    }
    
}

extension AddRecipeDetailViewController {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    // MARK: - TextViewDelegate
    fileprivate func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    // MARK: - TextfieldDelegate
    fileprivate func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
}







