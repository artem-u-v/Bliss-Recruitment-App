//
//  ChoiceCell.swift
//  BRA
//
//  Created by Artem Umanets on 29/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import UIKit

class ChoiceCell : UITableViewCell {
    @IBOutlet weak var buttonVote: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelVoteCount: UILabel!
    
    var choice : ChoiceModel!{
        didSet{
            self.labelTitle.text = choice.choice
            self.labelVoteCount.text = "(\(choice.votes))"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonVote.setTitle(loc("QuestionDetails.Vote"), for: .normal)
    }
    
    @IBAction func voteTapped(_ sender: Any) {
        print("TODO: Update API Method")
    }
}
