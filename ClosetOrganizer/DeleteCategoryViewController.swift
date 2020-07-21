//
//  DeleteCategoryViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 7/19/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class DeleteCategoryViewController: UIViewController {

    @IBOutlet var categoryName: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    var passedCategoryName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blurBackground()
        
        self.categoryName.text = self.passedCategoryName
        self.categoryName.textAlignment = .center
        
        self.editButton.layer.cornerRadius = 12
        self.deleteButton.layer.cornerRadius = 12
    }
    
    // blurs background
    private func blurBackground() {
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
    }


}
