//
//  NoConnectivityWidget.swift
//  BRA
//
//  Created by Artem Umanets on 30/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import UIKit

var _sharedWidget : NoConnectivityWidget? = nil

class NoConnectivityWidget: UIView {
    @IBOutlet weak var labelErrorMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        self.labelErrorMessage.text = loc("NoConnectivity.Message")
    }
    static func sharedWidget() -> NoConnectivityWidget {
        if _sharedWidget == nil{
            _sharedWidget = UINib(nibName: "NoConnectivityWidget", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? NoConnectivityWidget
        }
        return _sharedWidget!
    }
}
