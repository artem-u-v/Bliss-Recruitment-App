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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonRetry.setTitle(loc("Global.Retry"), for: .normal)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
    }
    
    static func show(message:String, onRetry: @escaping () -> Void){
        let widget = UINib(nibName: "RetryWidget", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as! RetryWidget
        widget.labelErrorMessage.text = message
        widget.retryHandler = onRetry
        
        DynamicModal.shared.show(modalView: widget)
    }

    @IBAction func retryTapped(_ sender: Any) {
        DynamicModal.shared.close { () in
            self.retryHandler()
        }
    }
}
