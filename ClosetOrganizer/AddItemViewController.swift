//
//  AddItemViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/18/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var colorField: UITextField!
    @IBOutlet weak var purchaseDateField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate:AddItemDelegate?
    
    var passedCategories:[String]!
    var selectedCategory:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        self.addButton.layer.cornerRadius = 12
        self.cancelButton.layer.cornerRadius = 12
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return passedCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return passedCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = passedCategories[row]
    }
    
    @IBAction func addItem(_ sender: Any) {
        let tempImage = UIImage(named: "tshirt.jpg")
        let newItem = ClosetItem(image: tempImage!,
                                 category: self.selectedCategory,
                                 brand: brandField.text!,
                                 model: modelField.text!,
                                 color: colorField.text!,
                                 purchaseDate: purchaseDateField.text!)
        
        delegate?.addNewItem(newItem: newItem)
    }
    
}
