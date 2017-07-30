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
    
    var activityLoader: UIActivityIndicatorView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.activityLoader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activityLoader.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        self.activityLoader.startAnimating()
        self.addSubview(self.activityLoader)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityLoader.startAnimating()
    }
}
