//
//  ViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 5/17/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var closetTableView: UITableView!
    
    var closetList:[ClosetItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

