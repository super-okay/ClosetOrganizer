//
//  SelectCategoryViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/30/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class SelectCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryTable: UITableView!
    
    var passedCategories:[String]!
    
    var delegate:selectCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.categoryTable.delegate = self
        self.categoryTable.dataSource = self
        
        self.categoryTable.layer.cornerRadius = 12
        self.categoryTable.layer.masksToBounds = true
        self.categoryTable.layer.borderWidth = 1
        self.categoryTable.layer.borderColor = UIColor.black.cgColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath as IndexPath)
        let currCategory = passedCategories[indexPath.row]
        cell.textLabel!.text = currCategory
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateCategory(selectedCategory: passedCategories[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }

}
