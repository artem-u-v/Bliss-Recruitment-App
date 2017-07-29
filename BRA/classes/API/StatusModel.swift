//
//  StatusModel.swift
//  BRA
//
//  Created by Artem Umanets on 29/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import SwiftyJSON

class StatusModel{
    let status: Bool
    
    init(data: JSON) {
        self.status = data["status"].stringValue.uppercased() == "OK"
    }
    
    func printDescription(){
        let description = "STATUS:\(self.status)"
        print(description)
    }
}
