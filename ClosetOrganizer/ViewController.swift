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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddItemDelegate{
    
    @IBOutlet weak var closetTableView: UITableView!
    
    var closetList:[ClosetItem] = []
    
    var categoryList:[String] = []
    
    var selectedIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closetTableView.delegate = self
        closetTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return closetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "closetItemCell", for: indexPath as IndexPath) as! ClosetItemCustomCell
        let currItem = closetList[indexPath.row]
        cell.itemImageView.image = currItem.image
        cell.brandName.text = currItem.brand
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
        }
        else
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let selectedItem = closetList[selectedIndex]
            detailVC.passedImage = selectedItem.image
            detailVC.passedBrand = selectedItem.brand
            detailVC.passedCategory = selectedItem.category
            detailVC.passedColor = selectedItem.color
            detailVC.passedPurchaseDate = selectedItem.purchaseDate
        }
    }
    
    // delegate function for adding new item
    func addNewItem(newItem: ClosetItem) {
        closetList.append(newItem)
        closetTableView.reloadData()
    }

}

