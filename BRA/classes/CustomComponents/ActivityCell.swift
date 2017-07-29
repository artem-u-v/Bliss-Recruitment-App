//
//  ActivityCell.swift
//  BRA
//
//  Created by Artem Umanets on 29/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import UIKit

class ActivityCell : UITableViewCell {
    
    static var heightForActivityCell:CGFloat = 44.0
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activity.startAnimating()
    }
}
