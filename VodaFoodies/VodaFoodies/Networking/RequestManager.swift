//
//  RequestManager.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/31/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation
import Alamofire

class RequestManager {
    
    static func sendRequest(_ req: Request, reqID: String, callBack: @escaping (_ reqID: String, _ result:Result)->Void){
        let request = RequestBuilder.buildRequest(req)
        request.validate().responseJSON { response in
            
            switch response.result{
                
            case .success(let value):
                if checkStatus(code: response.response?.statusCode) {
                    callBack(reqID, Result.success(result: value))
                }else{
                    callBack(reqID, Result.fail(error: RequestError(error: value as! String)))
                }
                
            case .failure(let error):
                let err = RequestError(error: error.localizedDescription)
                callBack(reqID, Result.fail(error: err))
            }
        }
    }
    
    private static func checkStatus(code: Int?) -> Bool{
        guard let code = code, (200..<300).contains(code) else {
            return false
        }
        return true
    }
}

enum Result {
    case fail(error: RequestError)
    case success(result: Any)
}
