//
//  OperationGetHealthStatus.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import SwiftyJSON

class OperationGetHealthStatus  : APIOperation{
    init() {
        let request = APIRequestModel(operation: "health")
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
