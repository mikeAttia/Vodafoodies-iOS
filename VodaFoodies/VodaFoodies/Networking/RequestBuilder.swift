//
//  RequestBuilder.swift
//  VodaFoodies
//
//  Created by Michael on 9/2/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation
import Alamofire

class RequestBuilder{

    /// Use to generate a request object from the type sent
    static func buildRequest(_ req: RequestType)/*should return a request object*/{
        
        switch req {
        case .user(let request):
            return buildUserRequest(request)
        case.venue(let request):
            return buildVenueRequest(request)
        case .userOrder(let request):
            return buildUserOrderRequest(request)
        case .venueOrder(let request):
            return buildVenueOrderRequest(request)
        }
        
    }
    
    private static func buildUserRequest(_ req: RequestType.UserRequest)/*should return a request object*/{
        
        switch req {
        case .updateUserData:// TODO: Associated value is User object
            break
        }
    }
    
    private static func buildVenueRequest(_ req: RequestType.VenueRequest)/*should return a request object*/{
        
        switch req {
        case .listedVenues:
//            return alamofireRequest(path: Const.Request.Path.listedVenuesPath)
            break
        case .venueMenu(venueID: _):break
        }
        
    }
    
    private static func buildVenueOrderRequest(_ req: RequestType.VenueOrderRequest)/*should return a request object*/{
        switch req {
        case .addVenueOrder:break
        case .getOpenOrders: break
        case .getOrderItemUsers(venueOrderId: _, itemId: _): break
        case .getOrderSum(venueOrderId: _): break
        case .getVenueOrderUsers(venueOrderId: _): break
        }
    }
    
    private static func buildUserOrderRequest(_ req: RequestType.UserOrderRequest)/*should return a request object*/{
        switch req {
        case .addUserOrder: break
        case .deleteUserOrder(venueOrderId: _): break
        case .deleteUserOrderItem(venueOrderId: _, itemId: _): break
        case .getUserOrders(venueID: _): break
        }
    }
    
    private static func alamofireRequest(path: String, method: HTTPMethod = .get, parameters: Parameters = [:]) -> DataRequest{
        let headers = [Const.Request.Keys.userId : Const.Global.userID]
        return Alamofire.request(Const.Request.Path.baseURL + path,
                          method: method,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
    }
    
//    Alamofire.request(<#T##url: URLConvertible##URLConvertible#>,
//    method: <#T##HTTPMethod#>,
//    parameters: <#T##Parameters?#>,
//    encoding: <#T##ParameterEncoding#>,
//    headers: <#T##HTTPHeaders?#>)
}
