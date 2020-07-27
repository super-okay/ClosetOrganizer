//
//  DeleteCategoryViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 7/19/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class DeleteCategoryViewController: UIViewController {

    @IBOutlet var categoryName: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    var passedCategoryName:String!
    
    var delegate:UpdateCategoryProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blurBackground()
        
        self.categoryName.text = self.passedCategoryName
        self.categoryName.textAlignment = .center
        
        self.editButton.layer.cornerRadius = 12
        self.deleteButton.layer.cornerRadius = 12
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

    @IBAction func editName(_ sender: Any) {
        let alert = UIAlertController(title: "Edit category name", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Enter new name..."
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            action in
            print("Saving new name")
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func deleteCategory(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "All items in this category will be moved to the 'All' category.", preferredStyle: .actionSheet)
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        noAction.titleTextColor = .black
        alert.addAction(noAction)
        
        let deleteAction = UIAlertAction(title: "Yes, delete this category", style: .default, handler: {
            action in
            print("Category deleted")
        })
        deleteAction.titleTextColor = .red
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true)
    }
    
}

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        }
        set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
