//
//  ClosetItem.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/17/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import Foundation
import UIKit

class ClosetItem {
    
    var image:UIImage!
    var brand:String!
    var color:String!
    var lastWorn:String!
    var purchaseDate:String!
    
    
    init(image:UIImage, brand:String, color:String) {
        self.image = image
        self.brand = brand
        self.color = color
    }
}
