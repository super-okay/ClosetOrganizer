//
//  SearchCategoryViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 6/8/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class SearchCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryTable: UITableViewCustom!
    
    var passedCategories:[String]!
    
    var delegate:searchCategoryProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        self.delegate?.setCategoryToSearch(category: passedCategories[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }

}
