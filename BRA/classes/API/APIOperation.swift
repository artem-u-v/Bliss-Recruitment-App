//
//  APIHandler.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import SwiftyJSON


typealias CompletionBlock = (_ result:AnyObject?, _ error: Error?) -> Void

class APIOperation{
    let request : APIRequestModel
    
    init(request:APIRequestModel){
        self.request = request
    }
    
    internal func makeRequest(completion:@escaping CompletionBlock){
        var urlRequest = URLRequest(url: self.request.requestURL)
        urlRequest.httpMethod = self.request.method.rawValue
        let session = URLSession.shared

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                let errorNoData = NSError(domain:kErrorDomain, code:kErrorNetworkNoData, userInfo:[NSLocalizedDescriptionKey:"Did not receive data"])
                completion(nil, errorNoData)
                return
            }
            
            //do {
            let json = JSON(data: responseData)
            guard json.error == nil else {
                let erroParsingJSON = NSError(domain:kErrorDomain, code:kErrorNetworkParsingJSON, userInfo:[NSLocalizedDescriptionKey:"Could not parse json response.", NSLocalizedFailureReasonErrorKey : json.error!.localizedDescription])
                completion(nil, erroParsingJSON)
                return
            }
            let responseModel = self.createModel(data: json)
            completion(responseModel, nil)
            
                /*
                guard let todo1 = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }

                print("The todo is: " + todo.description)
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)*/
            /*} catch  {
                print("error trying to convert data to JSON")
                return
            }*/
        }
        task.resume()
    }
    
    // Hook methods
    internal func createModel(data:JSON?) -> AnyObject{
        preconditionFailure("Unimplemented Method: This method needs to be overriden by a concrete subscass")
    }
}
