//
//  QuestionModel.swift
//  BRA
//
//  Created by Artem Umanets on 29/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChoiceModel{
    let choice: String
    let votes: Int
    
    init(data: JSON){
        self.choice = data["choice"].stringValue
        self.votes = data["votes"].intValue
    }
}

class QuestionModel{
    let id: Int
    let question: String
    let imageURL: URL
    let thumbURL: URL
    let publishedAt: Date
    let choices : [ChoiceModel]
    
    init(data: JSON) {
        self.id = data["id"].intValue
        self.question = data["question"].stringValue
        self.imageURL = URL(string: data["image_url"].stringValue)!
        self.thumbURL = URL(string: data["thumb_url"].stringValue)!
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        self.publishedAt = dateFormatter.date(from: data["published_at"].stringValue)!
        
        var choices = [ChoiceModel]()
        for choicesData in data["choices"].arrayValue {
            choices.append(ChoiceModel(data: choicesData))
        }
        self.choices = choices
    }
    
    func printDescription(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        var description = "ID:\(self.id)\nQUESTION:\(self.question)\nIMG:\(self.imageURL)\nTHUMB:\(self.thumbURL)\n"
        description += "PUBLISHED:\(dateFormatter.string(from: self.publishedAt))\n"
        description += "CHOICES:\n"
        
        for i in 0..<self.choices.count {
            description += "\t\(self.choices[i].choice) - \(self.choices[i].votes)\n"
        }
        print(description)
    }
}
