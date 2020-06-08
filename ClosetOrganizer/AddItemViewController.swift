//
//  AddItemViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/18/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit
import Foundation
import CoreData

protocol selectCategoryDelegate {
    func selectCategory(chosenCategory: String)
}

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, selectCategoryDelegate {

    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var categoryField: UITextFieldCustom!
    @IBOutlet weak var brandField: UITextFieldCustom!
    @IBOutlet weak var modelField: UITextFieldCustom!
    @IBOutlet weak var colorField: UITextFieldCustom!
    @IBOutlet weak var purchaseDateField: UITextFieldCustom!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate:AddItemDelegate?
    
    var passedCategories:[String]!
    var selectedCategory:String!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        categoryField.delegate = self
        categoryField.addTarget(self, action: #selector(categorySelector), for: .touchDown)
        
        self.addImageButton.layer.cornerRadius = 12
        self.addImageButton.layer.masksToBounds = true

        self.addButton.layer.cornerRadius = 12
        self.cancelButton.layer.cornerRadius = 12
        
        self.navigationItem.title = "Add New Item"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
    }
    
    // opens user's photo album for them to select image
    @IBAction func addImage(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // user has selected image from album
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageToAdd = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.addImageButton.setBackgroundImage(imageToAdd, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    // user cancels selecting image from album
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // displays category list when user taps category field
    @objc func categorySelector() {
        performSegue(withIdentifier: "selectCategorySegue", sender: nil)
    }
    
    // creating and adding new item from the form
    @IBAction func addItem(_ sender: Any) {
        
        var alert:UIAlertController!
        
        // valid form
        if validForm() {
            var imageToAdd = UIImage(named: "white_square.jpeg")
            if self.addImageButton.backgroundImage(for: .normal) != nil {
                imageToAdd = self.addImageButton.backgroundImage(for: .normal)
            }
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                     return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ClosetItem",
                                              in: managedContext)!
            let newItem = NSManagedObject(entity: entity, insertInto: managedContext)
            let imageData = imageToAdd?.jpegData(compressionQuality: 1)
            newItem.setValue(imageData, forKey: "image")
            newItem.setValue(self.selectedCategory, forKey: "category")
            newItem.setValue(self.brandField.text!, forKey: "brand")
            newItem.setValue(self.modelField.text!, forKey: "model")
            newItem.setValue(self.colorField.text!, forKey: "color")
            newItem.setValue(self.purchaseDateField.text!, forKey: "purchaseDate")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            delegate?.addNewItem(newItem: newItem)
            
            alert = UIAlertController(title: "Success!", message: "Your item has been added", preferredStyle: .alert)
            
            // dismisses "Success" alert after 1 second
            let timeToDismiss = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: timeToDismiss) {
                alert.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
            self.present(alert, animated: true)
        }
        // invalid form
        else {
            alert = UIAlertController(title: "Error", message: "Category, Brand, and Color fields must be filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    // exits the add item view
    @IBAction func cancelItem(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // checks whether the form has been filled correctly
    func validForm() -> Bool {
        var valid = false
        
        // valid
        if categoryField.text != "" && brandField.text != "" && colorField.text != "" {
            valid = true
        }
        
        return valid
    }
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCategorySegue" {
            let selectCategoryVC = segue.destination as! SelectCategoryViewController
            selectCategoryVC.delegate = self
            selectCategoryVC.passedCategories = self.passedCategories
        }
    }
    
    // protocol function for selecting category
    func selectCategory(chosenCategory: String) {
        self.selectedCategory = chosenCategory
        self.categoryField.text = chosenCategory
    }
}


// custom text field class
class UITextFieldCustom: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    private var shadowLayer: CAShapeLayer!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
//        self.layer.borderColor = UIColor.darkGray.cgColor
//        self.layer.borderWidth = 1
//        self.layer.cornerRadius = 12
//        self.layer.masksToBounds = true
        self.borderStyle = .none
        self.backgroundColor = .white
        self.frame.size.height = 46
        self.textColor = .darkGray
    }
    
    // adding shadow to textfield, this was way too hard
    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
          
            shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor

            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 4

            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
