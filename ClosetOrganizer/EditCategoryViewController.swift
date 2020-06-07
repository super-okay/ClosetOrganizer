//
//  SelectCategoryViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/30/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class EditCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryTable: UITableViewCustom!
    
    var passedCategories:[String]!
    
    var delegate:editCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.categoryTable.delegate = self
        self.categoryTable.dataSource = self
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
    
    // dismisses view when user touches outside table view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != categoryTable {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
