//
//  OperationListQuestions.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import SwiftyJSON

class OperationListQuestions : APIOperation{    
    init(offset: Int, limit: Int, filter:String? = nil) {
        let request = APIRequestModel(operation: "questions")
        request.appendArgument(name: "limit", value: String(limit))
        request.appendArgument(name: "offset", value: String(offset))
        if filter != nil{
            request.appendArgument(name: "filter", value: filter!)
        }
        super.init(request: request)
    }
    
    func performOperation(completion:@escaping (_ result:[QuestionModel]?, _ error: Error?) -> Void) {
        super.performOperation(completion: completion)
    }
    
    override func createModel(data:JSON) -> Any{
        var response = [QuestionModel]()
        for jsonQuestionData in data.arrayValue {
            let question = QuestionModel(data: jsonQuestionData)
            response.append(question)
        }
        return response
    }
}
