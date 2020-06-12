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
    var filteredList:[NSManagedObject] = []
    
    var selectedFilter:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsTable.delegate = self
        self.resultsTable.dataSource = self
        
        searchBySC.selectedSegmentIndex = 0
        searchBySC.sendActions(for: .valueChanged)
        
        self.navigationItem.rightBarButtonItem?.title = ""
        
        // registers custom tableview cell for reuse
        resultsTable.register(UINib(nibName: "ClosetItemCustomCell", bundle: nil), forCellReuseIdentifier: "closetItemCell")
    }
    
    // action function for segmented control
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
    
    // action for bar button item to change filter
    @IBAction func changeFilter(_ sender: Any) {
        self.performSegue(withIdentifier: "searchFilterSegue", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.filteredList.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "closetItemCell", for: indexPath as IndexPath) as! ClosetItemCustomCell
        if cell == nil {
            cell = ClosetItemCustomCell.createCell()!
        }
//        let currItem = filteredList[indexPath.row]
        cell.brand.text = "TEST"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchFilterSegue" {
            let searchFiltersVC = segue.destination as! SearchFiltersViewController
            searchFiltersVC.delegate = self
            if self.searchBySC.selectedSegmentIndex == 1 {
                searchFiltersVC.passedFilters = Array(passedCategories[1...])
            }
            else if self.searchBySC.selectedSegmentIndex == 2 {
                searchFiltersVC.passedFilters = self.passedBrands
            }
        }
    }
    
    // protocol function
    func setFilterToSearch(filter:String) {
        self.selectedFilter = filter
        self.searchBar.placeholder = "Searching in \(self.selectedFilter ?? "All")..."
    }
    
}
