//
//  NewCategoryViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 7/5/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController {

    @IBOutlet var newCategoryLabel: UILabel!
    @IBOutlet var newCategoryField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // blurs background
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)

//        self.newCategoryLabel.textColor = .white
        self.newCategoryField.frame.size.height = 42
        self.cancelButton.layer.cornerRadius = 12
        self.addButton.layer.cornerRadius = 12
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
    }
    
}
