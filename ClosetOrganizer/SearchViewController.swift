//
//  SearchViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 6/8/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit
import CoreData

protocol searchCategoryProtocol {
    func setCategoryToSearch(category:String)
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, searchCategoryProtocol {
    
    @IBOutlet weak var searchBySC: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTable: UITableView!
    
    var passedClosetDict:[String:[NSManagedObject]] = [:]
    var passedCategories:[String]!
    var filteredList:[NSManagedObject]!
    
    var selectedCategory:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBySC.selectedSegmentIndex = 0
        searchBySC.sendActions(for: .valueChanged)
    }
    
    @IBAction func searchBy(_ sender: Any) {
        switch searchBySC.selectedSegmentIndex {
        case 0:
            searchBar.placeholder = "Searching all items..."
            let allItems = self.passedClosetDict["All"]
        case 1:
            self.performSegue(withIdentifier: "searchCategorySegue", sender: nil)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath as IndexPath)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchCategorySegue" {
            let searchCategoryVC = segue.destination as! SearchCategoryViewController
            searchCategoryVC.delegate = self
            searchCategoryVC.passedCategories = self.passedCategories
        }
    }
    
    func setCategoryToSearch(category:String) {
        self.selectedCategory = category
        self.searchBar.placeholder = "Searching in \(self.selectedCategory ?? "All")..."
    }
    
}
