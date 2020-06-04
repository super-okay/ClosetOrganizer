//
//  AddItemViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/18/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

protocol selectCategoryDelegate {
    func selectCategory(chosenCategory: String)
}

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, selectCategoryDelegate {

    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var selectCategoryButton: UIButton!
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
        
        self.selectCategoryButton.layer.cornerRadius = 12
        self.categoryField.isUserInteractionEnabled = false

        self.addButton.layer.cornerRadius = 12
        self.cancelButton.layer.cornerRadius = 12
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
    
    // creating and adding new item from the form
    @IBAction func addItem(_ sender: Any) {
        
        var alert:UIAlertController!
        
        // valid form
        if validForm() {
            var imageToAdd = UIImage(named: "white_square.jpeg")
            if self.addImageButton.backgroundImage(for: .normal) != nil {
                imageToAdd = self.addImageButton.backgroundImage(for: .normal)
            }
            let newItem = ClosetItem(image: imageToAdd!,
                                     category: self.selectedCategory,
                                     brand: brandField.text!,
                                     model: modelField.text!,
                                     color: colorField.text!,
                                     purchaseDate: purchaseDateField.text!)
            
            delegate?.addNewItem(newItem: newItem)
            
            alert = UIAlertController(title: "Success!", message: "Your item has been added", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: { action in
                                            self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }
        // invalid form
        else {
            alert = UIAlertController(title: "Error", message: "Brand and Color fields must be filled", preferredStyle: .alert)
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.frame.size.height = 46
        self.textColor = .darkGray
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
