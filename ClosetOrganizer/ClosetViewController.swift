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
    func deleteItem(itemToDelete:ClosetItem)
}

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AddItemDelegate, EditItemDelegate{
    
    @IBOutlet weak var closetTableView: UITableView!
    var closetDict:[String:[ClosetItem]] = [:]
    
    @IBOutlet weak var categoryTabs: UICollectionView!
    var categoryList:[String] = []
    var currentCategory:String = "All"
    
    @IBOutlet weak var newCategoryButton: UIButton!
    @IBOutlet weak var newItemButton: UIButton!
    
    var selectedIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        categoryTabs.delegate = self
        categoryTabs.dataSource = self
        
        closetTableView.delegate = self
        closetTableView.dataSource = self
        
        newCategoryButton.layer.cornerRadius = 12
        newCategoryButton.clipsToBounds = true
        newItemButton.layer.cornerRadius = 12
        newItemButton.clipsToBounds = true
        
        closetDict["All"] = []
        closetDict["T-shirts"] = []
        closetDict["Jackets"] = []
        closetDict["Coats"] = []
        closetDict["Shorts"] = []
        closetDict["Pants"] = []
        
        categoryList = ["All", "T-shirts", "Jackets", "Coats", "Shorts", "Pants"]
        
        // removes extra table view dividers
        self.closetTableView.tableFooterView = UIView()
    }
    
    // sets title and styling of navigation bar
    private func setupNavBar() {
        self.navigationItem.title = "Closet"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
        
        // clear background, divider
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    // for fading of tableview edges
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if closetTableView.layer.mask == nil {
            let maskLayer = CAGradientLayer()
            maskLayer.locations = [0, 0.2, 0.8, 1]
            maskLayer.bounds = CGRect(x: 0, y: 0, width: closetTableView.frame.size.width, height: closetTableView.frame.size.height)
            maskLayer.anchorPoint = CGPoint.zero
            
            closetTableView.layer.mask = maskLayer
        }
        
        scrollViewDidScroll(closetTableView)
    }
    
    // applies fading to top and bottom of tableview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let outerColor = UIColor(white: 1, alpha: 0).cgColor
        let innerColor = UIColor(white: 1, alpha: 1).cgColor
        
        var colors = [CGColor]()
        
        if scrollView.contentOffset.y + scrollView.contentInset.top <= 0 {
            colors = [innerColor, innerColor, innerColor, outerColor]
        } else if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            colors = [outerColor, innerColor, innerColor, innerColor]
        } else {
            colors = [outerColor, innerColor, innerColor, outerColor]
        }
        
        if let mask = scrollView.layer.mask as? CAGradientLayer {
            mask.colors = colors

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            mask.position = CGPoint(x: 0.0, y: scrollView.contentOffset.y)
            CATransaction.commit()
        }
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
    
    // table cell content
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
        cell.itemImageView.layer.cornerRadius = 12
        cell.itemImageView.layer.masksToBounds = true
        
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
            detailVC.passedCategories = self.categoryList
        }
    }
    
    // handles action for adding new category
    @IBAction func newCategory(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (_ textField: UITextField) -> Void in
            textField.placeholder = "Name"
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
                (action) in
                self.dismiss(animated: true, completion: nil)
            }
        ))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
                (action) in
                let newCategory = alert.textFields?[0].text as! String
                self.closetDict[newCategory] = []
                self.categoryList.append(newCategory)
                self.categoryTabs.reloadData()
            }
        ))
        self.present(alert, animated: true)
    }
    
    
    // delegate function for adding new item
    func addNewItem(newItem: ClosetItem) {
        
        var allList = closetDict["All"]!
        allList.append(newItem)
        closetDict["All"] = allList
        
        if newItem.category != "All" {
            var listToAddTo = closetDict[newItem.category]!
            listToAddTo.append(newItem)
            closetDict[newItem.category] = listToAddTo
        }
        
        closetTableView.reloadData()
    }
    
    // delegate function, finds old item to replace with new, edited item
    func editExistingItem(oldItem:ClosetItem, newItem:ClosetItem) {
        
        var listToChange = closetDict[oldItem.category]!
        let editedIndex = listToChange.firstIndex(of: oldItem)!
        
        // category was not edited
        if oldItem.category == newItem.category {
            listToChange[editedIndex] = newItem
            closetDict[newItem.category] = listToChange
        }
        // category was edited
        else {
            if oldItem.category != "All" {
                listToChange.remove(at: editedIndex)
                closetDict[oldItem.category] = listToChange
            }
            
            var listToAddTo = closetDict[newItem.category]!
            listToAddTo.append(newItem)
            closetDict[newItem.category] = listToAddTo
        }
        
        var fullList = closetDict["All"]!
        let editedIndex2 = fullList.firstIndex(of: oldItem)
        fullList[editedIndex2!] = newItem
        closetDict["All"] = fullList
        
        closetTableView.reloadData()
    }
    
    // deletes item from closet
    func deleteItem(itemToDelete:ClosetItem) {
        
        var listToChange = closetDict[itemToDelete.category]!
        let indexToRemove = listToChange.firstIndex(of: itemToDelete)!
        
        if itemToDelete.category != "All" {
            listToChange.remove(at: indexToRemove)
            closetDict[itemToDelete.category] = listToChange
        }
        
        var fullList = closetDict["All"]!
        let indexToRemove2 = fullList.firstIndex(of: itemToDelete)!
        fullList.remove(at: indexToRemove2)
        closetDict["All"] = fullList
        
        closetTableView.reloadData()
    }

}
