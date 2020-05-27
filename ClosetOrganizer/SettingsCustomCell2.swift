//
//  SettingsCustomCell2.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/27/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class SettingsCustomCell2: UITableViewCell {

    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
