//
//  ViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/17/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

protocol AddItemDelegate {
    func addNewItem(newItem: ClosetItem)
}

protocol EditItemDelegate {
    func editExistingItem(oldItem:ClosetItem, newItem:ClosetItem)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AddItemDelegate, EditItemDelegate{
    
    @IBOutlet weak var closetTableView: UITableView!
    var closetList:[ClosetItem] = []
    var displayedList:[ClosetItem] = []
    var closetDict:[String:[ClosetItem]] = [:]
    
    @IBOutlet weak var categoryTabs: UICollectionView!
    var categoryList:[String] = []
    var currentCategory:String = "All"
    
    var selectedIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTabs.delegate = self
        categoryTabs.dataSource = self
        
        closetTableView.delegate = self
        closetTableView.dataSource = self
        
        closetDict["All"] = []
        closetDict["T-shirts"] = []
        closetDict["Jackets"] = []
        closetDict["Coats"] = []
        closetDict["Shorts"] = []
        closetDict["Pants"] = []
        closetDict["Graphic Tees"] = []
        closetDict["Really Long Name"] = []
        
        categoryList = ["All", "T-shirts", "Jackets", "Coats", "Shorts", "Pants", "Graphic Tees", "Really Long Name"]
        
        // removes extra table view dividers
        self.closetTableView.tableFooterView = UIView()
    }
    
    
    /* --------------- Collection View Functions --------------- */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryList.count
    }
    
    // size of collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var calculatedWidth = categoryList[indexPath.row].size(withAttributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
        ])
        calculatedWidth.height = 40
        
        return calculatedWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCustomCell
        cell.categoryLabel.text = categoryList[indexPath.row]
        cell.categoryLabel.textAlignment = .center
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        
        if cell.isSelected {
            cell.backgroundColor = .darkGray
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    // action for selecting category cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .darkGray
        cell?.isSelected = true
        currentCategory = categoryList[indexPath.row]
        closetTableView.reloadData()
    }
    
    // action for deselecting category cell
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .white
        cell?.isSelected = false
    }
    
    
    /* --------------- Table View Functions --------------- */

    // one row per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // one section for each item - this is for cell spacing design
    func numberOfSections(in tableView: UITableView) -> Int {
        return closetDict[currentCategory]!.count
    }
    
    // applies background color to spacing between cells
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    // spacing between cells
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "closetItemCell", for: indexPath as IndexPath) as! ClosetItemCustomCell
        let currItem = closetDict[currentCategory]![indexPath.section]
        cell.itemImageView.image = currItem.image
        cell.brand.text = currItem.brand
        cell.model.text = currItem.model
        cell.color.text = currItem.color
        cell.lastWorn.text = currItem.lastWorn
        
        // border and styling
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.section
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    
    /* --------------- Other Functions --------------- */
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemSegue" {
            let addItemVC = segue.destination as! AddItemViewController
            addItemVC.delegate = self
            addItemVC.passedCategories = categoryList
        }
        else
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.delegate = self
            let selectedItem = closetDict[currentCategory]![selectedIndex]
            detailVC.passedItem = selectedItem
        }
    }
    
    // delegate function for adding new item
    func addNewItem(newItem: ClosetItem) {
        
        var allList = closetDict["All"]!
        allList.append(newItem)
        closetDict["All"] = allList
        
        var listToAddTo = closetDict[newItem.category]!
        listToAddTo.append(newItem)
        closetDict[newItem.category] = listToAddTo
        
        closetTableView.reloadData()
    }
    
    // delegate function, finds old item to replace with new, edited item
    func editExistingItem(oldItem:ClosetItem, newItem:ClosetItem) {
        var listToChange = closetDict[oldItem.category]!
        let editedIndex = listToChange.firstIndex(of: oldItem)
        listToChange[editedIndex!] = newItem
        closetDict[newItem.category] = listToChange
        
        var fullList = closetDict["All"]!
        let editedIndex2 = fullList.firstIndex(of: oldItem)
        fullList[editedIndex2!] = newItem
        closetDict["All"] = fullList
        
        closetTableView.reloadData()
    }

}

