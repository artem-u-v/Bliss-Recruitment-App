//
//  ChoiceCell.swift
//  BRA
//
//  Created by Artem Umanets on 29/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import UIKit

protocol ChoiceDelegate : class {
    func incrementVote(sender:ChoiceCell, completion: @escaping (_ choice:ChoiceModel?) -> Void)
}

class ChoiceCell : UITableViewCell {
    @IBOutlet weak var buttonVote: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelVoteCount: UILabel!
    @IBOutlet weak var activityVote: UIActivityIndicatorView!
    
    weak var delegate : ChoiceDelegate!
    
    var choice : ChoiceModel!{
        didSet{
            self.labelTitle.text = choice.choice
            self.labelVoteCount.text = "(\(choice.votes))"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonVote.setTitle(loc("QuestionDetails.Vote"), for: .normal)
        self.activityVote.alpha = 0.0
    }
    
    @IBAction func voteTapped(_ sender: Any) {
        UIView.animate(withDuration: kAnimationSpeed) { 
            self.activityVote.alpha = 1.0
            self.buttonVote.alpha = 0.0
        }
        self.delegate.incrementVote(sender: self) { (choice:ChoiceModel?) in
            self.choice = choice
            UIView.animate(withDuration: kAnimationSpeed) {
                self.activityVote.alpha = 0.0
                self.buttonVote.alpha = 1.0
            }
        }
        
    }
}
