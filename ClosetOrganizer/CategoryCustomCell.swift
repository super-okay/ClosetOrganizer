//
//  CategoryCustomCell.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/21/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class CategoryCustomCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    // highlight selected cell
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                categoryLabel.textColor = .white
            } else {
                categoryLabel.textColor = .black
            }
        }
    }
    
}
