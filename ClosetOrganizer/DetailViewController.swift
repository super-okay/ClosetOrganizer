//
//  DetailViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/20/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit
import CoreData

protocol editCategoryProtocol {
    func updateCategory(selectedCategory: String)
}

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, editCategoryProtocol, selectDateProtocol {

    @IBOutlet weak var editCategoryButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var colorField: UITextField!
    @IBOutlet weak var purchaseDateField: UITextField!
    @IBOutlet weak var lastWornField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var passedItem:NSManagedObject!
    var passedCategories:[String]!
    
    let imagePicker = UIImagePickerController()
    
    var lastClicked:String!
    
    var delegate:EditItemProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFieldsToOriginal()
        applyStyling()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        self.purchaseDateField.delegate = self
        self.purchaseDateField.addTarget(self, action: #selector(purchaseDateSelector), for: .touchDown)
        
        self.lastWornField.delegate = self
        self.lastWornField.addTarget(self, action: #selector(lastWornDateSelector), for: .touchDown)
    }
    
    // helper func for viewDidLoad, applies styling to fields and buttons
    private func applyStyling() {
        self.editCategoryButton.layer.cornerRadius = 12
        self.editCategoryButton.isHidden = true
        
        self.itemImage.layer.cornerRadius = 12
        self.itemImage.layer.masksToBounds = true
        
        self.changeImageButton.layer.cornerRadius = 12
        self.changeImageButton.layer.borderWidth = 1
        self.changeImageButton.layer.borderColor = UIColor.darkGray.cgColor
        self.changeImageButton.isHidden = true
        
        self.brandField.isUserInteractionEnabled = false
        self.brandField.borderStyle = .none
        
        self.modelField.isUserInteractionEnabled = false
        self.modelField.borderStyle = .none
        
        self.colorField.isUserInteractionEnabled = false
        self.colorField.borderStyle = .none
        
        self.purchaseDateField.isUserInteractionEnabled = false
        self.purchaseDateField.borderStyle = .none
        
        self.lastWornField.isUserInteractionEnabled = false
        self.lastWornField.borderStyle = .none
        
        self.cancelButton.layer.cornerRadius = 12
        self.cancelButton.isHidden = true
        
        self.saveButton.layer.cornerRadius = 12
        self.saveButton.isHidden = true
    }
    
    // allows editing of item fields
    @IBAction func editItem(_ sender: Any) {
        self.editCategoryButton.isHidden = false
        
        self.changeImageButton.isHidden = false
        
        self.brandField.borderStyle = .roundedRect
        self.brandField.isUserInteractionEnabled = true
        
        self.modelField.borderStyle = .roundedRect
        self.modelField.isUserInteractionEnabled = true
        
        self.colorField.borderStyle = .roundedRect
        self.colorField.isUserInteractionEnabled = true
        
        self.purchaseDateField.borderStyle = .roundedRect
        self.purchaseDateField.isUserInteractionEnabled = true
        
        self.lastWornField.borderStyle = .roundedRect
        self.lastWornField.isUserInteractionEnabled = true
        
        self.cancelButton.isHidden = false
        self.saveButton.isHidden = false
    }
    
    // displays date selector when user taps purchase date field
    @objc func purchaseDateSelector() {
        self.lastClicked = "purchaseDate"
        performSegue(withIdentifier: "datePickerSegue", sender: nil)
    }
    
    // displays date selector when user taps last worn field
    @objc func lastWornDateSelector() {
        self.lastClicked = "lastWornDate"
        performSegue(withIdentifier: "datePickerSegue", sender: nil)
    }
    
    // deletes item
    @IBAction func deleteItem(_ sender: Any) {
        let alert = UIAlertController(title: "Delete this item", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {
                (action) in
                self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
                (action) in
                self.delegate?.deleteItem(itemToDelete: self.passedItem)
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    
    // helper function, sets fields to item's original properties
    private func setFieldsToOriginal() {
        self.categoryLabel.text = passedItem.value(forKey: "category") as? String
        self.itemImage.image = UIImage(data: passedItem.value(forKey: "image") as! Data)
        self.brandField.text = passedItem.value(forKey: "brand") as? String
        self.modelField.text = passedItem.value(forKey: "model") as? String
        self.colorField.text = passedItem.value(forKey: "color") as? String
        self.purchaseDateField.text = passedItem.value(forKey: "purchaseDate") as? String
        self.lastWornField.text = passedItem.value(forKey: "lastWorn") as? String
    }
    
    // helper function, returns to default view, removes user interaction and borders
    private func defaultView() {
        self.editCategoryButton.isHidden = true
        
        self.changeImageButton.isHidden = true
        
        self.brandField.isUserInteractionEnabled = false
        self.brandField.borderStyle = .none
        
        self.modelField.isUserInteractionEnabled = false
        self.modelField.borderStyle = .none
        
        self.colorField.isUserInteractionEnabled = false
        self.colorField.borderStyle = .none
        
        self.purchaseDateField.isUserInteractionEnabled = false
        self.purchaseDateField.borderStyle = .none
        
        self.lastWornField.isUserInteractionEnabled = false
        self.lastWornField.borderStyle = .none
        
        self.cancelButton.isHidden = true
        self.saveButton.isHidden = true
    }
    
    // opens user's photo album for them to select image
    @IBAction func changeImage(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // user has selected image from album
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageToAdd = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.itemImage.image = imageToAdd
        self.dismiss(animated: true, completion: nil)
    }
    
    // user cancels selecting image from album
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // cancels the current edit
    @IBAction func cancelEdit(_ sender: Any) {
        setFieldsToOriginal()
        defaultView()
    }
    
    // saves the current edit
    @IBAction func saveEdit(_ sender: Any) {
        
        defaultView()
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // new code for testing editing item in core data
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ClosetItem")
        let oldCategory = self.passedItem.value(forKey: "category")
        let oldBrand = self.passedItem.value(forKey: "brand")
        let oldModel = self.passedItem.value(forKey: "model")
        let oldColor = self.passedItem.value(forKey: "color")
        fetchRequest.predicate = NSPredicate(format: "category = %@ AND brand = %@ AND model = %@ AND color = %@", argumentArray: [oldCategory!, oldBrand!, oldModel!, oldColor!])
        
        var editedItem:NSManagedObject!
        do {
            let tempList = try managedContext.fetch(fetchRequest)
            editedItem = tempList[0]
            let imageData = self.itemImage.image?.jpegData(compressionQuality: 1)
            tempList[0].setValue(imageData, forKey: "image")
            tempList[0].setValue(self.categoryLabel.text!, forKey: "category")
            tempList[0].setValue(self.brandField.text!, forKey: "brand")
            tempList[0].setValue(self.modelField.text!, forKey: "model")
            tempList[0].setValue(self.colorField.text!, forKey: "color")
            tempList[0].setValue(self.purchaseDateField.text!, forKey: "purchaseDate")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        delegate?.editExistingItem(oldItem: self.passedItem, newItem: editedItem)
    }
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCategorySegue" {
            let editCategoryVC = segue.destination as! EditCategoryViewController
            editCategoryVC.delegate = self
            editCategoryVC.passedCategories = self.passedCategories
        }
        else if segue.identifier == "datePickerSegue" {
            let datePickerVC = segue.destination as! DatePickerViewController
            datePickerVC.delegate = self
        }
    }
    
    // protocol function for updating category
    func updateCategory(selectedCategory: String) {
        self.categoryLabel.text = selectedCategory
    }

    // protocol function for selecting purchase date
    func selectDate(chosenDate: String) {
        if self.lastClicked == "purchaseDate" {
            self.purchaseDateField.text = chosenDate
        }
        else if self.lastClicked == "lastWornDate" {
            self.lastWornField.text = chosenDate
        }
    }
    
}
