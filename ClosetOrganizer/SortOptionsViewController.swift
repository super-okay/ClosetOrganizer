//
//  SortOptionsViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 6/23/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class SortOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var sortOptionsTable: PopupTableView!
    
    var sortOptions:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sortOptionsTable.delegate = self
        self.sortOptionsTable.dataSource = self
        
//        self.view.backgroundColor = UIColor.clear
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.insertSubview(blurEffectView, at: 0)
        
        self.sortOptions = ["Date Added (Default)", "Brand A-Z", "Brand Z-A", "Purchase Date", "Most Worn", "Least Worn"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sortOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortOptionsCell", for: indexPath as IndexPath)
        cell.textLabel?.text = self.sortOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // dismisses view when user touches outside table view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != self.sortOptionsTable {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
