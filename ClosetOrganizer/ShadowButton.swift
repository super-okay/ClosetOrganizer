//
//  ShadowButton.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 6/15/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import Foundation
import UIKit

// custom button class
class ShadowButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
    }
    
    // adding shadow to button
    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()

            shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor

            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3

            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
