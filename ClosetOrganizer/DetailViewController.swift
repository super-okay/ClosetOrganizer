//
//  DetailViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/20/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

protocol selectCategoryDelegate {
    func updateCategory(selectedCategory: String)
}

class DetailViewController: UIViewController, selectCategoryDelegate {

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
    
    var passedItem:ClosetItem!
    var passedCategories:[String]!
    
    var delegate:EditItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editCategoryButton.layer.cornerRadius = 12
        self.editCategoryButton.isHidden = true
        
        self.categoryLabel.text = passedItem.category

        self.itemImage.image = passedItem.image
        self.itemImage.layer.cornerRadius = 12
        self.itemImage.layer.masksToBounds = true
        
        self.changeImageButton.layer.cornerRadius = 12
        self.changeImageButton.layer.borderWidth = 1
        self.changeImageButton.layer.borderColor = UIColor.darkGray.cgColor
        self.changeImageButton.isHidden = true
        
        self.brandField.text = passedItem.brand
        self.brandField.isUserInteractionEnabled = false
        self.brandField.borderStyle = .none
        
        self.modelField.text = passedItem.model
        self.modelField.isUserInteractionEnabled = false
        self.modelField.borderStyle = .none
        
        self.colorField.text = passedItem.color
        self.colorField.isUserInteractionEnabled = false
        self.colorField.borderStyle = .none
        
        self.purchaseDateField.text = passedItem.purchaseDate
        self.purchaseDateField.isUserInteractionEnabled = false
        self.purchaseDateField.borderStyle = .none
        
        self.lastWornField.text = passedItem.lastWorn
        self.lastWornField.isUserInteractionEnabled = false
        self.lastWornField.borderStyle = .none
        
        self.cancelButton.layer.cornerRadius = 12
        self.cancelButton.isHidden = true
        
        self.saveButton.layer.cornerRadius = 12
        self.saveButton.isHidden = true
    }
    
    // allows editing of item
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
    
    // helper function, returns to default view, removes user interaction and borders
    func defaultView() {
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
    
    // cancels the current edit
    @IBAction func cancelEdit(_ sender: Any) {
        self.categoryLabel.text = passedItem.category
        self.itemImage.image = passedItem.image
        self.brandField.text = passedItem.brand
        self.modelField.text = passedItem.model
        self.colorField.text = passedItem.color
        self.purchaseDateField.text = passedItem.purchaseDate
        self.lastWornField.text = passedItem.lastWorn
        
        defaultView()
    }
    
    // saves the current edit
    @IBAction func saveEdit(_ sender: Any) {
        
        defaultView()
        
        let editedItem = ClosetItem(image: self.itemImage.image!, category: self.categoryLabel.text!, brand: self.brandField.text!, model: self.modelField.text!, color: self.colorField.text!, purchaseDate: self.purchaseDateField.text!)
        
        delegate?.editExistingItem(oldItem: self.passedItem, newItem: editedItem)
    }
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCategorySegue" {
            let selectCategoryVC = segue.destination as! SelectCategoryViewController
            selectCategoryVC.delegate = self
            selectCategoryVC.passedCategories = self.passedCategories
        }
    }
    
    // protocol function for updating category
    func updateCategory(selectedCategory: String) {
        self.categoryLabel.text = selectedCategory
    }
    
}
