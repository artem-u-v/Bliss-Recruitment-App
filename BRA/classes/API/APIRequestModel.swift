//
//  APIRequest.swift
//  BRA
//
//  Created by Artem Umanets on 29/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation

struct APIArgument{
    var name: String
    var value: String
}

enum OperationMethod : String{
    case get = "GET"
    case post = "POST"
}

class APIRequestModel{
    let operation : String
    let method : OperationMethod
    private var arguments : [APIArgument] = [APIArgument]()
    
    var requestURL : URL{
        get{
            var arguments = ""
            if self.arguments.count > 0{
                arguments = "?"
                for var i in 0..<self.arguments.count{
                    arguments += self.arguments[i].value
                    if i < self.arguments.count - 1{
                        arguments += "&"
                    }
                }
            }
            let finalURL = URL(string:"\(APIEndpointURL)\(self.operation)\(arguments)")!
            print("URL:", finalURL)
            return finalURL
        }
    }
    
    init(operation: String, method:OperationMethod = .get) {
        self.operation = operation
        self.method = method
    }
    
    func appendArgument(name:String, value:String){
        let argument = APIArgument(name: name, value: value)
        self.arguments.append(argument)
    }
}
