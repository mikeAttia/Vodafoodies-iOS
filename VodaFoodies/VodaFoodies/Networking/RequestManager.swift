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
    
    
    static func sendRequest(_ req: RequestType, reqID: String, callBack: ()->Void){
        let request = RequestType.buildRequest(req) // Should return an alamofire request
        
        
    }
}

enum Result {
    case fail
    case success
}
