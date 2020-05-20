//
//  DetailViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/20/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var purchaseDate: UILabel!
    @IBOutlet weak var lastWorn: UILabel!
    
    var passedImage:UIImage!
    var passedBrand:String!
    var passedCategory:String!
    var passedColor:String!
    var passedPurchaseDate:String!
    var passedLastWorn:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.itemImage.image = passedImage
        self.brand.text = passedBrand
        self.category.text = passedCategory
        self.color.text = passedColor
        self.purchaseDate.text = passedPurchaseDate
    }
    

}
