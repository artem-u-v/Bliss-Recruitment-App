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
    case put = "PUT"
}

enum DataContentType : String{
    case json = "application/json"
    case text = "text/plain"
}

class APIRequestModel{
    let operation : String
    let method : OperationMethod
    private var url : String
    
    var postData: String?
    var postDataContentType: DataContentType?
    
    private var arguments : [APIArgument] = [APIArgument]()
    
    func getRequest() -> URLRequest{
        var urlRequest : URLRequest!
        
        if self.method == .get{
            url  = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            urlRequest = URLRequest(url: URL(string: url)!)
            if let contentType = self.postDataContentType{
                urlRequest.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
            }
            if let postData = self.postData{
                urlRequest.httpBody = postData.data(using: String.Encoding.utf8)
            }
        }
        urlRequest.httpMethod = self.method.rawValue
        return urlRequest
    }
    
    init(operation: String, method:OperationMethod = .get) {
        self.operation = operation
        self.method = method
        self.url = "\(APIEndpointURL)\(self.operation)"
    }
    
    func appendQueryStringArgument(name:String?, value:String, argumentAsSubpath:Bool = false){
        if argumentAsSubpath{
            self.url += "/\(value)"
        }else{
            if self.url.contains("?"){
                self.url += "&\(value)"
            }else{
                self.url += "?\(value)"
            }
        }
    }
}
