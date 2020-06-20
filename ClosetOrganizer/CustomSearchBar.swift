//
//  CustomSearchBar.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 6/19/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import Foundation
import UIKit

// custom search bar class, is actually a text field
class CustomSearchBar: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    private var shadowLayer: CAShapeLayer!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.borderStyle = .none
        self.backgroundColor = .white
        self.textColor = .darkGray
    }
    
    // adding shadow
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
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
