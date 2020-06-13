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

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, searchFiltersProtocol {
    
    @IBOutlet weak var searchBySC: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var changeButton: UIBarButtonItem!
    
    var passedClosetDict:[String:[NSManagedObject]] = [:]
    var passedCategories:[String]!
    var passedBrands:[String]!
    
    var fullList:[NSManagedObject]!
    var filteredList:[NSManagedObject] = []
    
    var selectedFilter:String!
    
    // checks if search bar is currently active
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsTable.delegate = self
        self.resultsTable.dataSource = self
        
        searchBySC.selectedSegmentIndex = 0
        searchBySC.sendActions(for: .valueChanged)
        
        self.navigationItem.rightBarButtonItem?.title = ""
        
        // registers custom tableview cell for reuse
        resultsTable.register(UINib(nibName: "ClosetItemCustomCell", bundle: nil), forCellReuseIdentifier: "closetItemCell")
        
        self.fullList = self.passedClosetDict["All"]
        
        // removes extra table view dividers
        self.resultsTable.tableFooterView = UIView()
        self.resultsTable.separatorStyle = .none
        
        self.searchBar.delegate = self
        
    }
    
    // action function for segmented control
    @IBAction func searchBy(_ sender: Any) {
        switch searchBySC.selectedSegmentIndex {
        case 0:
            searchBar.placeholder = "Searching all items..."
            self.navigationItem.rightBarButtonItem?.title = ""
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
        if isFiltering {
            return self.filteredList.count
        }
        return self.fullList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "closetItemCell", for: indexPath as IndexPath) as! ClosetItemCustomCell
        if cell == nil {
            cell = ClosetItemCustomCell.createCell()!
        }
        
        // determines which list to select from
        let currItem:NSManagedObject!
        if isFiltering {
            currItem = self.filteredList[indexPath.row]
        } else {
            currItem = self.fullList[indexPath.row]
        }

        cell.itemImageView.image = UIImage(data: currItem.value(forKey: "image") as! Data)
        cell.brand.text = currItem.value(forKey: "brand") as? String
        cell.model.text = currItem.value(forKey: "model") as? String
        cell.color.text = currItem.value(forKey: "color") as? String
        cell.lastWorn.text = currItem.value(forKey: "lastWorn") as? String
        
        // border and styling
        cell.itemImageView.layer.cornerRadius = 12
        cell.itemImageView.layer.masksToBounds = true
        
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
    
    /********************  Search Bar Functions ********************/
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchBar.text == "" {
            self.isFiltering = false
        } else {
            self.isFiltering = true
        }
        self.filteredList = self.fullList.filter {
            (closetItem: NSManagedObject) -> Bool in
            let category = closetItem.value(forKey: "category") as? String
            let brand = closetItem.value(forKey: "brand") as? String
            let model = closetItem.value(forKey: "model") as? String
            let color = closetItem.value(forKey: "color") as? String
            let returnBool = category!.lowercased().contains(searchText.lowercased()) || brand!.lowercased().contains(searchText.lowercased()) || model!.lowercased().contains(searchText.lowercased()) || color!.lowercased().contains(searchText.lowercased())
            return returnBool
        }
        
        self.resultsTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFiltering = true
    }
}

