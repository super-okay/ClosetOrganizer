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
    @IBOutlet weak var brandField: UITextFieldCustom!
    @IBOutlet weak var modelField: UITextFieldCustom!
    @IBOutlet weak var colorField: UITextFieldCustom!
    @IBOutlet weak var purchaseDateField: UITextFieldCustom!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate:AddItemDelegate?
    
    var passedCategories:[String]!
    var selectedCategory:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelItem(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

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
