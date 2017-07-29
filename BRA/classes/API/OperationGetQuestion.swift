//
//  OperationGetQuestion.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import SwiftyJSON

class OperationGetQuestion : APIOperation{
    init(questionId: Int) {
        let request = APIRequestModel(operation: "questions", argumentAsSubpath: true)
        request.appendArgument(name: "question_id", value: String(questionId))
        super.init(request: request)
    }
    
    func performOperation(completion:@escaping (_ result:QuestionModel?, _ error: Error?) -> Void) {
        super.performOperation(completion: completion)
    }
    
    override func createModel(data:JSON) -> Any{
        let question = QuestionModel(data: data)
        return question
    }
}
