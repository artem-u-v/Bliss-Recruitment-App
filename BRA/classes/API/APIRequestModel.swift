//
//  APIRequestModel.swift
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
    let argumentAsSubpath : Bool
    let method : OperationMethod
    private var arguments : [APIArgument] = [APIArgument]()
    
    func getRequest() -> URLRequest{
        var urlRequest : URLRequest!
        var url = "\(APIEndpointURL)\(self.operation)"
        
        if self.method == .get{
            url.append(self.getArgumentsList())
            urlRequest = URLRequest(url: URL(string: url)!)
        }else if self.method == .post{
            urlRequest = URLRequest(url: URL(string: url)!)
            urlRequest.httpBody = self.getArgumentsList().data(using: String.Encoding.utf8)
        }
        urlRequest.httpMethod = self.method.rawValue
        return urlRequest
    }
    
    private func getArgumentsList() -> String{
        var arguments = ""
        if self.arguments.count > 0{
            if self.method == .get{
                if self.argumentAsSubpath && self.arguments.count == 1{
                    arguments = "/\(self.arguments[0].value)"
                }else{
                    arguments = "?"
                    for i in 0..<self.arguments.count{
                        arguments += self.arguments[i].value
                        if i < self.arguments.count - 1{
                            arguments += "&"
                        }
                    }
                }
            }else{
                for i in 0..<self.arguments.count{
                    arguments += "\(self.arguments[i].name)=\(self.arguments[i].value)"
                    if i < self.arguments.count - 1{
                        arguments += "&"
                    }
                }
            }
            
        }
        return arguments
    }
    
    /*private var requestURLforMethodPOST : URL{
        get{
            var url = "\(APIEndpointURL)\(self.operation)"
            return URL(string: url)
        }
    }
    
    private var requestURLforMethodGET : URL{
        get{
            var url = "\(APIEndpointURL)\(self.operation)"
            if self.method == .get && self.argumentAsSubpath && self.arguments.count == 1{
                url.append("/\(self.arguments[0].value)")
            }else{
                url.append(self.getArgumentsList())
            }
            return URL(string: url)!
        }
    }*/
    
    init(operation: String, argumentAsSubpath:Bool = false, method:OperationMethod = .get) {
        self.operation = operation
        self.argumentAsSubpath = argumentAsSubpath
        self.method = method
    }
    
    func appendArgument(name:String, value:String){
        let argument = APIArgument(name: name, value: value)
        self.arguments.append(argument)
    }
}
