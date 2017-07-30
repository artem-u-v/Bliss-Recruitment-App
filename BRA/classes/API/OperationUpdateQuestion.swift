//
//  OperationUpdateQuestion.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import SwiftyJSON

class OperationUpdateQuestion : APIOperation{
    init(question: QuestionModel) {
        let request = APIRequestModel(operation: "questions")
        request.appendQueryStringArgument(name: "question_id", value: String(question.id), argumentAsSubpath: true)
        request.postDataContentType = .json
        request.postData = "Object data in JSON format"
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
