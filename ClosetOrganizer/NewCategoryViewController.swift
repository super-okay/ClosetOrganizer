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
    
    var delegate: newCategoryProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // blurs background
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)

//        self.newCategoryLabel.textColor = .white
        self.newCategoryField.frame.size.height = 42
        self.cancelButton.layer.cornerRadius = 12
        self.addButton.layer.cornerRadius = 12
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        // NEED TO ERROR CHECK in case user adds no text
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
        let newCategory = NSManagedObject(entity: entity, insertInto: managedContext)
        newCategory.setValue(self.newCategoryField.text!, forKey: "name")
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
