//
//  ImageCell.swift
//  BRA
//
//  Created by Artem Umanets on 29/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import UIKit

class ImageCell : UITableViewCell {
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var buttonReload: UIButton!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    var imageUrl:URL!{
        didSet{
            self.loadImageAsync()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonReload.alpha = 0.0;
        self.imagePhoto.alpha = 0.0;
        self.activityLoader.startAnimating()
    }
    
    // MARK: Actions
    @IBAction func loadImageTapped(_ sender: Any) {
        self.loadImageAsync()
    }
    
    // MARK: Utils
    func loadImageAsync(){
        self.imagePhoto.loadImageAsync(withUrl: self.imageUrl) { (image:UIImage?, error:Error?) in
            guard error == nil else {
                UIView.animate(withDuration: kAnimationSpeed, animations: {
                    self.buttonReload.alpha = 1.0
                    self.imagePhoto.alpha = 0.0
                    self.activityLoader.alpha = 0.0
                })
                return
            }
            
            UIView.animate(withDuration: kAnimationSpeed, animations: {
                self.buttonReload.alpha = 0.0
                self.imagePhoto.alpha = 1.0
                self.activityLoader.alpha = 0.0
            })
        }
    }
}
