//
//  OperationGetQuestion.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import SwiftyJSON

class OperationShare  : APIOperation{
    init(email: String, url:String) {
        let request = APIRequestModel(operation: "share", argumentAsSubpath: false, method: .post)
        request.appendArgument(name: "destination_email", value: String(email))
        request.appendArgument(name: "content_url", value: String(url))
        super.init(request: request)
    }
    
    func performOperation(completion:@escaping (_ result:StatusModel?, _ error: Error?) -> Void) {
        super.performOperation(completion: completion)
    }
    
    override func createModel(data:JSON) -> Any{
        let status = StatusModel(data: data)
        return status
    }
}
