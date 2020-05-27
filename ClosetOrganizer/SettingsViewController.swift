//
//  SettingsViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/17/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingsTable: UITableView!
    
    var settingsList:[String] = [
        "Setting1",
        "Dark mode"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTable.delegate = self
        settingsTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell1", for: indexPath as IndexPath) as! SettingsCustomCell
            cell.settingLabel.text = settingsList[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell2", for: indexPath as IndexPath) as! SettingsCustomCell2
            cell.settingLabel.text = settingsList[indexPath.row]
            return cell
        }
        
    }

}
