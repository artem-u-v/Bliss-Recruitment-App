//
//  APIOperation.swift
//  BRA
//
//  Created by Artem Umanets on 28/07/2017.
//  Copyright © 2017 Seedrop. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias CompletionBlock = (_ result:Any?, _ error: Error?) -> Void

class APIOperation{
    let request : APIRequestModel
    
    init(request:APIRequestModel){
        self.request = request
    }
    
    internal func makeRequest(completion:@escaping CompletionBlock){
        let urlRequest = self.request.getRequest()
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
            
            let json = JSON(data: responseData)
            guard json.error == nil else {
                let erroParsingJSON = NSError(domain:kErrorDomain, code:kErrorNetworkParsingJSON, userInfo:[NSLocalizedDescriptionKey:"Could not parse json response.", NSLocalizedFailureReasonErrorKey : json.error!.localizedDescription])
                completion(nil, erroParsingJSON)
                return
            }
            let responseModel = self.createModel(data: json)
            completion(responseModel, nil)
        }
        task.resume()
    }
    
    internal func performOperation<T : Any>(onSuccess:@escaping (_ result:T) -> Void, onError:@escaping (_ error: Error) -> Void) {
        self.makeRequest { (result, error) in
            DispatchQueue.main.async {
                guard error == nil else{
                    onError(error!)
                    return
                }
                onSuccess(result as! T)
            }
        }
    }
    
    // Hook methods
    internal func createModel(data:JSON) -> Any{
        preconditionFailure("Unimplemented Method: This method needs to be overriden by a concrete subscass")
    }
}
