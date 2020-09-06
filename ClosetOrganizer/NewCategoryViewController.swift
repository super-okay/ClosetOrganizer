//
//  NewCategoryViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 7/5/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit
import CoreData

class NewCategoryViewController: UIViewController {

    @IBOutlet var newCategoryLabel: UILabel!
    @IBOutlet var newCategoryField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    var passedCategories:[String]!
    
    var delegate: newCategoryProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurBackground()

//        self.newCategoryLabel.textColor = .white
        self.newCategoryField.frame.size.height = 42
        self.cancelButton.layer.cornerRadius = 12
        self.addButton.layer.cornerRadius = 12
    }
    
    // blurs background
    private func blurBackground() {
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        let newCategoryName = self.newCategoryField.text!
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // non-empty field
        if !trimmedName.isEmpty {
            var lowercasedCategories:[String] = []
            for category in self.passedCategories {
                lowercasedCategories.append(category.lowercased())
            }
            
            // category already exists
            if lowercasedCategories.contains(trimmedName.lowercased()) {
                self.newCategoryField.text = ""
                let alert = UIAlertController(title: "Error", message: "Category already exists", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alert, animated: true)
            }
            // valid new category
            else {
                guard let appDelegate =
                  UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
                let newCategory = NSManagedObject(entity: entity, insertInto: managedContext)
                newCategory.setValue(trimmedName, forKey: "name")
                newCategory.setValue(Date(), forKey: "dateAdded")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
                delegate?.addNewCategory(newCategory: newCategory)
                self.dismiss(animated: true, completion: nil)
            }
        }
        // empty field
        else {
            let alert = UIAlertController(title: "Error", message: "Category name cannot be blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true)
        }
    }
    
}
