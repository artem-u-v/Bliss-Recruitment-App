//
//  DateCell.swift
//  BRA
//
//  Created by Artem Umanets on 29/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import UIKit

class DateCell : UITableViewCell {

    var date:Date!{
        didSet{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.detailTextLabel?.text = dateFormatter.string(from: self.date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.text = loc("QuestionDetails.PublishedDate")
    }
}
