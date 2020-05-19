//
//  AddItemViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/18/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var colorField: UITextField!
    @IBOutlet weak var purchaseDateField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate:AddItemDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addButton.layer.cornerRadius = 12
        self.cancelButton.layer.cornerRadius = 12
    }
    
    @IBAction func addItem(_ sender: Any) {
        let tempImage = UIImage(named: "tshirt.jpg")
        let tempCategory = "TEMP_CATEGORY"
        let newItem = ClosetItem(image: tempImage!, category: tempCategory, brand: brandField.text!, color: colorField.text!, purchaseDate: purchaseDateField.text!)
        delegate?.addNewItem(newItem: newItem)
    }
    
}
