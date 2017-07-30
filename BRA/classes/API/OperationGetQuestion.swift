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
        let request = APIRequestModel(operation: "questions")
        request.appendQueryStringArgument(name: "question_id", value: String(questionId), argumentAsSubpath: true)
        super.init(request: request)
    }
    
    func performOperation(onSuccess:@escaping (_ result:QuestionModel) -> Void, onError:@escaping (_ error:Error) -> Void) {
        super.performOperation(onSuccess: onSuccess, onError: onError)
    }
    
    override func createModel(data:JSON) -> Any{
        let question = QuestionModel(data: data)
        return question
    }
}
