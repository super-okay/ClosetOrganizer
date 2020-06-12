//
//  ClosetItemCustomCell.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/17/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class ClosetItemCustomCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var lastWorn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func createCell() -> ClosetItemCustomCell? {
        let nib = UINib(nibName: "ClosetItemCustomCell", bundle: nil)
        let cell = nib.instantiate(withOwner: self, options: nil).last as? ClosetItemCustomCell
        return cell
    }

}
