//
//  RetryWidget.swift
//  BRA
//
//  Created by Artem Umanets on 30/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import UIKit

class RetryWidget: UIView {
    @IBOutlet weak var labelErrorMessage: UILabel!
    @IBOutlet weak var buttonRetry: UIButton!
    
    private var retryHandler: (() -> Void)!
    
    static func createWidget(message:String, retryHandler: @escaping () -> Void) -> RetryWidget{
        let widget = UINib(nibName: "RetryWidget", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as! RetryWidget
        widget.labelErrorMessage.text = message
        widget.retryHandler = retryHandler
        
        return widget
    }

    @IBAction func retryTapped(_ sender: Any) {
        self.retryHandler()
    }
}
