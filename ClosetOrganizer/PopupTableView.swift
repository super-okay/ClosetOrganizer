//
//  PopupTableView.swift
//  ClosetOrganizer
//
//  Created by Allen Wang on 6/9/20.
//  Copyright © 2020 Allen Wang. All rights reserved.
//

import Foundation
import UIKit

// custom table view class for popups
class PopupTableView: UITableView {

    private var shadowLayer: CAShapeLayer!

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor

        // removes extra table view dividers
        self.tableFooterView = UIView()
    }

}
