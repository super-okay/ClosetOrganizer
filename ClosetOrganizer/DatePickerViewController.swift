//
//  DatePickerViewController.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 7/3/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var confirmButton: UIButton!
    
    var delegate:selectDateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // blurs background
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)

//        self.datePicker.setValue(UIColor.white, forKeyPath: "textColor")
//        self.datePicker.setValue(false, forKeyPath: "highlightsToday")
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.layer.cornerRadius = 12
        self.datePicker.layer.masksToBounds = true
//        self.datePicker.maximumDate = Date()
        
        self.confirmButton.layer.cornerRadius = 12
    }
    
    @IBAction func confirmDate(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let dateToShow = dateFormatter.string(from: self.datePicker.date)
        self.delegate?.selectDate(chosenDate: dateToShow)
        self.dismiss(animated: true, completion: nil)
    }
    
    // dismisses view when user touches outside table view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != self.datePicker {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
