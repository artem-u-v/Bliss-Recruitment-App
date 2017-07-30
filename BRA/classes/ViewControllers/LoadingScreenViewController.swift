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
        healthStatusOperation.performOperation(onSuccess: { (status:StatusModel) in
            self.performSegue(withIdentifier: "Navigate to Question List", sender: nil)
        }) { (error) in
            RetryWidget.show(message: loc("LoadingScreen.ServerStatusNotOK"), onRetry: {
                self.validateServerHealth()
            })
        }
    }
}
