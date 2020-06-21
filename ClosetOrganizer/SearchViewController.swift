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

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, searchFiltersProtocol, EditItemProtocol {
    
    @IBOutlet weak var searchBySC: UISegmentedControl!
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var changeFilterButton: ShadowButton!
    @IBOutlet var visibleHeightConstraint: NSLayoutConstraint!
    
    var passedClosetDict:[String:[NSManagedObject]] = [:]
    var passedCategories:[String]!
    var passedBrands:[String]!
    
    var originalFullList:[NSManagedObject]!
    var fullList:[NSManagedObject]!
    var filteredList:[NSManagedObject] = []
    
    var selectedFilter:String!
    
    var selectedIndex:Int!
    
    var delegate:EditItemProtocol?
    
    // checks if search bar is currently active
//    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsTable.delegate = self
        self.resultsTable.dataSource = self
        
        // sets segmented control to "All Items" (default)
        searchBySC.selectedSegmentIndex = 0
        searchBySC.sendActions(for: .valueChanged)
        
        self.visibleHeightConstraint.constant = 0
        self.changeFilterButton.setTitle("", for: .normal)
        
        // registers custom tableview cell for reuse
        resultsTable.register(UINib(nibName: "ClosetItemCustomCell", bundle: nil), forCellReuseIdentifier: "closetItemCell")
        
        self.originalFullList = self.passedClosetDict["All"]
        self.fullList = self.passedClosetDict["All"]
        self.filteredList = self.fullList
        
        // removes extra table view dividers
        self.resultsTable.tableFooterView = UIView()
        self.resultsTable.separatorStyle = .none
        
        // detects every text change for search bar
        self.searchBar.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // action function for segmented control
    @IBAction func searchBy(_ sender: Any) {
        switch searchBySC.selectedSegmentIndex {
        case 0:
            self.searchBar.placeholder = "Searching all items..."
            self.visibleHeightConstraint.constant = 0
            self.changeFilterButton.setTitle("", for: .normal)
            self.fullList = self.passedClosetDict["All"]
            self.filteredList = self.passedClosetDict["All"]!
            self.resultsTable.reloadData()
        case 1:
            self.visibleHeightConstraint.constant = 34
            self.changeFilterButton.setTitle("Change Category Filter", for: .normal)
            self.performSegue(withIdentifier: "searchFilterSegue", sender: nil)
        case 2:
            self.visibleHeightConstraint.constant = 34
            self.changeFilterButton.setTitle("Change Brand Filter", for: .normal)
            self.performSegue(withIdentifier: "searchFilterSegue", sender: nil)
        default:
            break
        }
    }
    
    // action for change filter button
    @IBAction func changeFilter(_ sender: Any) {
        self.performSegue(withIdentifier: "searchFilterSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBar.text != "" {
            return self.filteredList.count
        }
        return self.fullList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "closetItemCell", for: indexPath as IndexPath) as! ClosetItemCustomCell
        
        // determines which list to select from
        let currItem:NSManagedObject!

        if self.searchBar.text != "" {
            currItem = self.filteredList[indexPath.row]
        } else {
            currItem = self.fullList[indexPath.row]
        }
        
        cell.itemImageView.image = UIImage(data: currItem.value(forKey: "image") as! Data)
        cell.brand.text = currItem.value(forKey: "brand") as? String
        cell.model.text = currItem.value(forKey: "model") as? String
        cell.color.text = currItem.value(forKey: "color") as? String
        cell.lastWorn.text = currItem.value(forKey: "lastWorn") as? String
        
        // image styling
        cell.itemImageView.layer.cornerRadius = 12
        cell.itemImageView.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "searchToDetailSegue", sender: nil)
    }
    
    // prepare for segue
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
        else if segue.identifier == "searchToDetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.delegate = self
            if self.searchBar.text == "" {
                detailVC.passedItem = self.fullList[selectedIndex]
            } else {
                detailVC.passedItem = self.filteredList[selectedIndex]
            }
            detailVC.passedCategories = self.passedCategories
        }
    }
    
    // search filters protocol function
    func setFilterToSearch(filter:String) {
        self.selectedFilter = filter
        self.searchBar.placeholder = "Searching in \(self.selectedFilter ?? "All")..."
        
        self.fullList = self.originalFullList
        self.fullList = self.fullList.filter {
            (closetItem: NSManagedObject) -> Bool in
            var match:Bool!
            if self.searchBySC.selectedSegmentIndex == 1 {
                let category = closetItem.value(forKey: "category") as? String
                match = category == self.selectedFilter
            }
            else if self.searchBySC.selectedSegmentIndex == 2 {
                let brand = closetItem.value(forKey: "brand") as? String
                match = brand == self.selectedFilter
            }
            return match
        }
        self.filteredList = self.fullList
        self.resultsTable.reloadData()
    }
    
    // edit item protocol function
    func editExistingItem(oldItem: NSManagedObject, newItem: NSManagedObject) {
        self.delegate?.editExistingItem(oldItem: oldItem, newItem: newItem)
        self.searchBar.text = ""
        fetchData()
        self.resultsTable.reloadData()
    }
    
    // edit item protocol function
    func deleteItem(itemToDelete: NSManagedObject) {
        self.delegate?.deleteItem(itemToDelete: itemToDelete)
        self.searchBar.text = ""
        fetchData()
        self.resultsTable.reloadData()
    }
    
    // fetches items from core data, puts into dictionary
    private func fetchData() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ClosetItem")
        
        do {
            let temp = try managedContext.fetch(fetchRequest)
            self.passedClosetDict["All"] = temp
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        self.fullList = self.passedClosetDict["All"]!
        self.filteredList = self.fullList
        
        // loads items into respective categories
        for item in passedClosetDict["All"]! {
            let category = item.value(forKey: "category") as? String
            if category != "All" {
                var listToAddTo = passedClosetDict[category!]
                listToAddTo!.append(item)
                passedClosetDict[category!] = listToAddTo
            }
            
            // add brand to brand list
            self.passedBrands.append((item.value(forKey: "brand") as? String)!)
        }
    }
    
    /********************  Search Bar Functions ********************/
    
    // detects every text change for search bar
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.filteredList = self.fullList.filter {
            (closetItem: NSManagedObject) -> Bool in
            let category = closetItem.value(forKey: "category") as? String
            let brand = closetItem.value(forKey: "brand") as? String
            let model = closetItem.value(forKey: "model") as? String
            let color = closetItem.value(forKey: "color") as? String
            let returnBool = category!.lowercased().contains(textField.text!.lowercased()) || brand!.lowercased().contains(textField.text!.lowercased()) || model!.lowercased().contains(textField.text!.lowercased()) || color!.lowercased().contains(textField.text!.lowercased())
            return returnBool
        }

        self.resultsTable.reloadData()
    }
    
}

