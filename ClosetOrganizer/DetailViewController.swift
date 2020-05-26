//
//  DetailViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/20/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var colorField: UITextField!
    @IBOutlet weak var purchaseDateField: UITextField!
    @IBOutlet weak var lastWorn: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var passedImage:UIImage!
    var passedBrand:String!
    var passedModel:String!
    var passedCategory:String!
    var passedColor:String!
    var passedPurchaseDate:String!
    var passedLastWorn:String!
    
    var delegate:EditItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.itemImage.image = passedImage
        
        self.brandField.text = passedBrand
        self.brandField.isUserInteractionEnabled = false
        self.brandField.borderStyle = .none
        
        self.modelField.text = passedModel
        self.modelField.isUserInteractionEnabled = false
        self.modelField.borderStyle = .none
        
        self.colorField.text = passedColor
        self.colorField.isUserInteractionEnabled = false
        self.colorField.borderStyle = .none
        
        self.purchaseDateField.text = passedPurchaseDate
        self.purchaseDateField.isUserInteractionEnabled = false
        self.purchaseDateField.borderStyle = .none
        
        self.saveButton.layer.cornerRadius = 12
        self.saveButton.isHidden = true
    }
    
    @IBAction func editItem(_ sender: Any) {
        self.brandField.borderStyle = .roundedRect
        self.brandField.isUserInteractionEnabled = true
        
        self.modelField.borderStyle = .roundedRect
        self.modelField.isUserInteractionEnabled = true
        
        self.colorField.borderStyle = .roundedRect
        self.colorField.isUserInteractionEnabled = true
        
        self.purchaseDateField.borderStyle = .roundedRect
        self.purchaseDateField.isUserInteractionEnabled = true
        
        self.saveButton.isHidden = false
    }
    
    @IBAction func saveEdit(_ sender: Any) {
        self.brandField.isUserInteractionEnabled = false
        self.brandField.borderStyle = .none
        
        self.modelField.isUserInteractionEnabled = false
        self.modelField.borderStyle = .none
        
        self.colorField.isUserInteractionEnabled = false
        self.colorField.borderStyle = .none
        
        self.purchaseDateField.isUserInteractionEnabled = false
        self.purchaseDateField.borderStyle = .none
        
        self.saveButton.isHidden = true
    }
    
    
}
