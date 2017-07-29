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
    
    @IBOutlet weak var viewRetryWidget: UIView!
    @IBOutlet weak var labelStatusInfo: UILabel!
    @IBOutlet weak var buttonRetry: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelStatusInfo.text = loc("LoadingScreen.ServerStatusNotOK")
        self.buttonRetry.setTitle(loc("LoadingScreen.Retry"), for: .normal)
        
        self.viewRetryWidget.alpha = 0.0
        self.validateServerHealth()
    }

    func validateServerHealth(){
        let healthStatusOperation = OperationGetHealthStatus()
        healthStatusOperation.performOperation { (status:StatusModel?, error:Error?) in
            guard error == nil else{
                print("An error occurred processing request: \(error!.localizedDescription)")
                UIView.animate(withDuration: kAnimationSpeed, animations: { 
                    self.viewRetryWidget.alpha = 1.0
                    self.activityLoading.alpha = 0.0
                })
                return
            }
            self.performSegue(withIdentifier: "Navigate to Question List", sender: nil)
        }
    }
    
    // MARK: Actions
    @IBAction func retryTapped(_ sender: Any) {
        UIView.animate(withDuration: kAnimationSpeed, animations: { 
            self.viewRetryWidget.alpha = 0.0
            self.activityLoading.alpha = 1.0
        }) { (completed) in
            self.validateServerHealth()
        }
    }
}
