//
//  ViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/17/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit
import CoreData

protocol AddItemProtocol {
    func addNewItem(newItem: NSManagedObject)
}

protocol EditItemProtocol {
    func editExistingItem(oldItem:NSManagedObject, newItem:NSManagedObject)
    func deleteItem(itemToDelete:NSManagedObject)
}

protocol newCategoryProtocol {
    func addNewCategory(newCategory: NSManagedObject)
}

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AddItemProtocol, EditItemProtocol, newCategoryProtocol {
    
    @IBOutlet weak var closetTableView: UITableView!
    var closetDict:[String:[NSManagedObject]] = [:]
    
    @IBOutlet weak var categoryTabs: UICollectionView!
    var categoryList:[String] = []
    var currentCategory:String = "All"
    
    var brandList:[String] = []
    
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
        
        newCategoryButton.layer.borderWidth = 1
        newCategoryButton.layer.borderColor = UIColor.darkGray.cgColor
        newCategoryButton.layer.cornerRadius = 12
        newCategoryButton.clipsToBounds = true
        
        newItemButton.layer.cornerRadius = 12
        newItemButton.clipsToBounds = true
        
//        closetDict["All"] = []
//        closetDict["T-shirts"] = []
//        closetDict["Jackets"] = []
//        closetDict["Coats"] = []
//        closetDict["Shorts"] = []
//        closetDict["Pants"] = []
//
//        categoryList = ["All", "T-shirts", "Jackets", "Coats", "Shorts", "Pants"]
        fetchCategories()
        
        // selects + highlights the "All" category tab upon page load
        self.categoryTabs.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        
        // removes extra table view dividers
        self.closetTableView.tableFooterView = UIView()
        self.closetTableView.separatorStyle = .none
        
        // fetch ClosetItems from core data
        fetchClosetItems()
    }
    
    // bugs when user is on a category that is not "All", visits detail page of an item, comes back
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        // selects + highlights the "All" category tab upon view appearing
//        self.categoryTabs.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
//    }
    
    // sets title and styling of navigation bar
    private func setupNavBar() {
        self.navigationItem.title = "Closet"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Nunito-SemiBold", size: 24)]
        
        // clear background, divider
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    // fetches items from core data, puts into dictionary
    private func fetchClosetItems() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ClosetItem")
        
        do {
            var coreDataList = try managedContext.fetch(fetchRequest)
            coreDataList.reverse() // recent items appear on top
            closetDict["All"] = coreDataList
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // loads items into respective categories
        for item in closetDict["All"]! {
            let category = item.value(forKey: "category") as? String
            if category != "All" {
                var listToAddTo = closetDict[category!]
                listToAddTo!.append(item)
                closetDict[category!] = listToAddTo
            }
            
            // add brand to brand list
            let brand = (item.value(forKey: "brand") as? String)!
            if !self.brandList.contains(brand) {
                self.brandList.append(brand)
            }
        }
    }
    
    // fetches categories from core data, loads into categoryList
    private func fetchCategories() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        
        var coreDataCategories:[NSManagedObject]!
        do {
            coreDataCategories = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // first time initialization of app
        if coreDataCategories.count == 0 {
            let categoriesToAdd = ["All", "T-shirts", "Jackets", "Coats", "Shorts", "Pants"]
            let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
            for name in categoriesToAdd {
                let newCategory = NSManagedObject(entity: entity, insertInto: managedContext)
                newCategory.setValue(name, forKey: "name")
                newCategory.setValue(Date(), forKey: "dateAdded")
                self.closetDict[name] = []
                self.categoryList.append(name)
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        // not first time initializing app
        else {
            let sort = NSSortDescriptor(key: #keyPath(Category.dateAdded), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            var sortedCategories:[NSManagedObject]!
            do {
                sortedCategories = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            for item in sortedCategories {
                let name = item.value(forKey: "name") as? String
                self.closetDict[name!] = []
                self.categoryList.append(name!)
            }
        }
    }

    
    // for fading of tableview edges
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if closetTableView.layer.mask == nil {
            let maskLayer = CAGradientLayer()
            maskLayer.locations = [0, 0.1, 0.9, 1]
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
        return 0
    }
    
    // table cell content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "closetItemCell", for: indexPath as IndexPath) as! ClosetItemCustomCell
        let currItem = closetDict[currentCategory]![indexPath.section]

        cell.itemImageView.image = UIImage(data: currItem.value(forKey: "image") as! Data)
        cell.brand.text = currItem.value(forKey: "brand") as? String
        cell.model.text = currItem.value(forKey: "model") as? String
        cell.color.text = currItem.value(forKey: "color") as? String
        cell.lastWorn.text = currItem.value(forKey: "lastWorn") as? String
        
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
        else if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.delegate = self
            let selectedItem = closetDict[currentCategory]![selectedIndex]
            detailVC.passedItem = selectedItem
            detailVC.passedCategories = self.categoryList
        }
        else if segue.identifier == "searchSegue" {
            let searchVC = segue.destination as! SearchViewController
            searchVC.delegate = self
            searchVC.passedClosetDict = self.closetDict
            searchVC.passedCategories = self.categoryList
            searchVC.passedBrands = self.brandList
        }
        else if segue.identifier == "newCategorySegue" {
            let newCategoryVC = segue.destination as! NewCategoryViewController
            newCategoryVC.delegate = self
        }
    }
    
    // delegate function for adding new category
    func addNewCategory(newCategory: NSManagedObject) {
        let newName = newCategory.value(forKey: "name") as? String
        self.closetDict[newName!] = []
        self.categoryList.append(newName!)
        self.categoryTabs.reloadData()
    }
    
    // delegate function for adding new item
    func addNewItem(newItem: NSManagedObject) {
        
        var allList = closetDict["All"]!
//        allList.append(newItem)
        allList.insert(newItem, at: 0)
        closetDict["All"] = allList
        
        let newCategory = (newItem.value(forKey: "category") as? String)!
        
        if newItem.value(forKey: "category") as? String != "All" {
            var listToAddTo = closetDict[newCategory]!
//            listToAddTo.append(newItem)
            listToAddTo.insert(newItem, at: 0)
            closetDict[newCategory] = listToAddTo
        }
        
        closetTableView.reloadData()
    }
    
    // delegate function, finds old item to replace with new, edited item
    func editExistingItem(oldItem:NSManagedObject, newItem:NSManagedObject) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let oldCategory = (oldItem.value(forKey: "category") as? String)!
        let newCategory = (newItem.value(forKey: "category") as? String)!
        
        var listToChange = closetDict[oldCategory]!
        let editedIndex = findIndexOfItem(itemToFind: oldItem, listToSearch: listToChange)
        
        // category was not edited
        if oldCategory == newCategory {
            listToChange[editedIndex] = newItem
            closetDict[newCategory] = listToChange
        }
        // category was edited
        else {
            if oldCategory != "All" {
                listToChange.remove(at: editedIndex)
                closetDict[oldCategory] = listToChange
            }
            
            var listToAddTo = closetDict[newCategory]!
//            listToAddTo.append(newItem)
            listToAddTo.insert(newItem, at: 0)
            closetDict[newCategory] = listToAddTo
        }
        
        var fullList = closetDict["All"]!
        let editedIndex2 = findIndexOfItem(itemToFind: oldItem, listToSearch: fullList)
        
        fullList[editedIndex2] = newItem
        closetDict["All"] = fullList
        
        closetTableView.reloadData()
    }
    
    // deletes item from closet
    func deleteItem(itemToDelete:NSManagedObject) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let itemCategory = (itemToDelete.value(forKey: "category") as? String)!
        
        var listToChange = closetDict[itemCategory]!
        let indexToRemove = findIndexOfItem(itemToFind: itemToDelete, listToSearch: listToChange)
        
        if itemCategory != "All" {
            // remove old item from core data
            managedContext.delete(listToChange[indexToRemove])
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            listToChange.remove(at: indexToRemove)
            closetDict[itemCategory] = listToChange
        }
        
        var fullList = closetDict["All"]!
        let indexToRemove2 = findIndexOfItem(itemToFind: itemToDelete, listToSearch: fullList)
        
        // remove old item from core data
        managedContext.delete(fullList[indexToRemove2])
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        fullList.remove(at: indexToRemove2)
        closetDict["All"] = fullList
        
        closetTableView.reloadData()
    }
    
    // finds the index of a closet item in a category list, used for editing and deleting
    private func findIndexOfItem(itemToFind:NSManagedObject, listToSearch:[NSManagedObject]) -> Int {
        var itemFound = false
        var index = 0
        while !itemFound && index < listToSearch.count {
            let curritem = listToSearch[index]
            itemFound = itemsMatch(a: curritem, b: itemToFind)
            index += 1
        }
        index -= 1
        
        return index
    }
    
    // checks if two closet item entities are the same
    private func itemsMatch(a:NSManagedObject, b:NSManagedObject) -> Bool {
        let brand1 = a.value(forKey: "brand") as? String
        let model1 = a.value(forKey: "model") as? String
        let color1 = a.value(forKey: "color") as? String
        
        let brand2 = b.value(forKey: "brand") as? String
        let model2 = b.value(forKey: "model") as? String
        let color2 = b.value(forKey: "color") as? String
        
        return brand1 == brand2 && model1 == model2 && color1 == color2
    }

}

