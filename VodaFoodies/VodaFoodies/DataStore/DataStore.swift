//
//  DataStore.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/31/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

class DataStore {
    
    private static var _shared: DataStore? = nil
    /// Shared instance of the Class
    static var shared: DataStore{
        if let shared = _shared{
            return shared
        }else{
            _shared = DataStore(qeue: [:])
            return _shared!
        }
    }
    
    // A dict carrying the requests and their generated IDs
    private var requestsQeue: [String: (type: RequestType, callBack: ()->Void)]
    
    // private init to instantiate the shared instance
    private init(qeue: [String: (type: RequestType, callBack: ()->Void)]) {
        self.requestsQeue = qeue
    }
    
    /// Use to fire a request and get the data in the callback
    func getData(req: RequestType, callBack: @escaping ()  ->Void) {
        // Generating and storing the request ID
        let requestID = UUID().uuidString
        requestsQeue[requestID] = (type: req, callBack: callBack)
        
        // Sending the request with the callback
        RequestManager.sendRequest(req, reqID: requestID, callBack: handleResult)
    }
    
    func handleResult() {
        //TODO: get the result, and get the proper request with the ID and handle the result accordingly
    }
}
