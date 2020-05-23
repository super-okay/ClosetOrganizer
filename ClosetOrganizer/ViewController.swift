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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AddItemDelegate{
    
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
        
//        categoryList = [String] (closetDict.keys)
        
        categoryList = ["All", "T-shirts", "Jackets", "Coats", "Shorts", "Pants", "Graphic Tees", "Really Long Name"]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryList.count
    }
    
    // size of collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCustomCell
        cell.categoryLabel.text = categoryList[indexPath.row]
        cell.categoryLabel.textAlignment = .center
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        
        if cell.isSelected {
            cell.backgroundColor = .gray
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    // action for selecting category cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .gray
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return closetDict[currentCategory]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "closetItemCell", for: indexPath as IndexPath) as! ClosetItemCustomCell
        let currItem = closetDict[currentCategory]![indexPath.row]
        cell.itemImageView.image = currItem.image
        cell.brand.text = currItem.brand
        cell.model.text = currItem.model
        cell.color.text = currItem.color
        cell.lastWorn.text = currItem.lastWorn
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemSegue" {
            let addItemVC = segue.destination as! AddItemViewController
            addItemVC.delegate = self
            addItemVC.passedCategories = categoryList
        }
        else
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let selectedItem = closetDict[currentCategory]![selectedIndex]
            detailVC.passedImage = selectedItem.image
            detailVC.passedBrand = selectedItem.brand
            detailVC.passedModel = selectedItem.model
            detailVC.passedCategory = selectedItem.category
            detailVC.passedColor = selectedItem.color
            detailVC.passedPurchaseDate = selectedItem.purchaseDate
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

}

