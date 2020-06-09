//
//  SearchViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 6/8/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit
import CoreData

protocol searchFiltersProtocol {
    func setFilterToSearch(filter:String)
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, searchFiltersProtocol {
    
    @IBOutlet weak var searchBySC: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var changeButton: UIBarButtonItem!
    
    var passedClosetDict:[String:[NSManagedObject]] = [:]
    var passedCategories:[String]!
    var passedBrands:[String]!
    var filteredList:[NSManagedObject]!
    
    var selectedFilter:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBySC.selectedSegmentIndex = 0
        searchBySC.sendActions(for: .valueChanged)
        
        self.navigationItem.rightBarButtonItem?.title = ""
    }
    
    @IBAction func searchBy(_ sender: Any) {
        switch searchBySC.selectedSegmentIndex {
        case 0:
            searchBar.placeholder = "Searching all items..."
            self.navigationItem.rightBarButtonItem?.title = ""
            let allItems = self.passedClosetDict["All"]
        case 1:
            self.navigationItem.rightBarButtonItem?.title = "Change Category"
            self.performSegue(withIdentifier: "searchFilterSegue", sender: nil)
        case 2:
            self.navigationItem.rightBarButtonItem?.title = "Change Brand"
            self.performSegue(withIdentifier: "searchFilterSegue", sender: nil)
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
        if segue.identifier == "searchFilterSegue" {
            let searchFiltersVC = segue.destination as! SearchFiltersViewController
            searchFiltersVC.delegate = self
            if self.searchBySC.selectedSegmentIndex == 1 {
                searchFiltersVC.passedFilters = self.passedCategories
            }
            else if self.searchBySC.selectedSegmentIndex == 2 {
                searchFiltersVC.passedFilters = self.passedBrands
            }
        }
    }
    
    func setFilterToSearch(filter:String) {
        self.selectedFilter = filter
        self.searchBar.placeholder = "Searching in \(self.selectedFilter ?? "All")..."
    }
    
}
