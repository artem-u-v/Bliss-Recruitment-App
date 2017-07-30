//
//  LoadingScreenViewController.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.validateServerHealth()
    }

    func validateServerHealth(){
        let healthStatusOperation = OperationGetHealthStatus()
        healthStatusOperation.performOperation { (status:StatusModel?, error:Error?) in
            guard error == nil else{
                let v = RetryWidget.createWidget(message: loc("LoadingScreen.ServerStatusNotOK"), retryHandler: {
                    DynamicModal.shared.close({ () in
                        self.validateServerHealth()
                    })
                })
                DynamicModal.shared.show(modalView: v)
                return
            }
            self.performSegue(withIdentifier: "Navigate to Question List", sender: nil)
        }
    }
}
