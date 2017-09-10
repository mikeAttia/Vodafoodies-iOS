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
    private var requestsQeue: [String: Request]
    
    // private init to instantiate the shared instance
    private init(qeue: [String: Request]) {
        self.requestsQeue = qeue
    }
    
    /// Use to fire a request and get the data in the callback
    func getData(req: Request) {
        // Generating and storing the request ID
        let requestID = UUID().uuidString
        requestsQeue[requestID] = req
        
        // Sending the request with the callback
        RequestManager.sendRequest(req, reqID: requestID, callBack: handleResult)
    }
    
    private func handleResult(reqID: String, res: Result){
        // retrieving the request using the ID
        guard let request = requestsQeue.removeValue(forKey: reqID) else{
            printError("No such Request was found", title: "Response handling")
            return
        }
        
        //Getting the result/Error object
        var error : RequestError?
        var result : Any?
        
        switch res {
        case .success(result: let res):
            result = res
        case .fail(error: let err):
            error = err
        }
        
        _handleResult(request: request, result: result, error: error)
        
    }
    
    private func _handleResult(request: Request, result: Any?, error: RequestError?){
        switch request {
        case .user(let userRequest):
            handleUserResult(userRequest, result: result, error: error)
        case .userOrder(let userOrderRequest):
            handleUserOrderRequest(userOrderRequest, result: result, error: error)
        case .venue(let venueRequest):
            handleVenueResult(venueRequest, result: result, error: error)
        case .venueOrder(let venueOrderRequest):
            handleVenueOrderResult(venueOrderRequest, result: result, error: error)
        }
    }
    
    private func handleUserResult(_ req: Request.UserRequest, result: Any?, error: RequestError?){
        
        switch req {
        case .updateUserData(userData: _, callBack: let callBack):
            callBack(error)
        }
    }
    
    private func handleVenueResult(_ req: Request.VenueRequest, result: Any?, error: RequestError?){
        
        switch req {
        case .listedVenues(callBack: let callBack):
            callBack(ResponseParser.getVenuesFrom(result), error)
        case .venueMenu(venueID: _, callBack: let callBack):
            callBack(ResponseParser.getMenuFrom(result), error)
        }
    }
    
    private func handleVenueOrderResult(_ req: Request.VenueOrderRequest, result: Any?, error: RequestError?){
        switch req {
        case .addVenueOrder(venueID: _, time: _, order: _, callBack: let callBack):
            callBack(error)
        case .getOpenOrders(callBack: _):
            break
        case .getOrderItemUsers(venueOrderId: _, itemId: _, callBack: _):
            fatalError("NOT IMPLEMENTED YET")
        case .getOrderSum(venueOrderId: _, callBack: _):
            fatalError("NOT IMPLEMENTED YET")
        case .getVenueOrderUsers(venueOrderId: _, callBack: _):
            fatalError("NOT IMPLEMENTED YET")
        }
    }
    
    private func handleUserOrderRequest(_ req: Request.UserOrderRequest, result: Any?, error: RequestError?){
        switch req {
        case .addUserOrder(callBack: _):
            fatalError("NOT IMPLEMENTED YET")
        case .deleteUserOrder(venueOrderId: _, callBack: _):
            fatalError("NOT IMPLEMENTED YET")
        case .deleteUserOrderItem(venueOrderId: _, itemId: _, callBack: _):
            fatalError("NOT IMPLEMENTED YET")
        case .getUserOrders(venueOrderID: _, callBack: let callBack):
            callBack(ResponseParser.getUserOrdersFrom(result), error)
        }
    }
    
    
}
