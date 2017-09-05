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
    static func buildRequest(_ req: Request)-> DataRequest{
        
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
    
    private static func buildUserRequest(_ req: Request.UserRequest)-> DataRequest{
        
        switch req {
        case .updateUserData(userData: let userData, callBack: _):
            let params: Parameters = [userData.firebaseID : [
                "name" :userData.name,
                "email" : userData.email,
                "img" : userData.imageURL,
                "phone" : userData.phoneNo,
                "fb_profile" : userData.profile
                ]]
            
            return alamofireRequest(path: Const.Request.Path.updateUserDataPath,
                                    method: .post,
                                    parameters: params)
        }
    }
    
    private static func buildVenueRequest(_ req: Request.VenueRequest)-> DataRequest{
        
        switch req {
        case .listedVenues(callBack: _):
            return alamofireRequest(path: Const.Request.Path.listedVenuesPath)
        case .venueMenu(venueID: let venueID, callBack: _):
            let params: Parameters = ["venue_id" : venueID]
            return alamofireRequest(path: Const.Request.Path.venueMenuPath,
                                    method: .get,
                                    parameters: params)
        }
    }
    
    private static func buildVenueOrderRequest(_ req: Request.VenueOrderRequest)-> DataRequest{
        switch req {
        case .addVenueOrder:
            fatalError("NOT IMPLEMENTED YET")
        case .getOpenOrders:
            return alamofireRequest(path: Const.Request.Path.getOpenOrdersPath)
        case .getOrderItemUsers(venueOrderId: _, itemId: _, callBack: _):
            fatalError("NOT IMPLEMENTED YET")
        case .getOrderSum(venueOrderId: _):
            fatalError("NOT IMPLEMENTED YET")
        case .getVenueOrderUsers(venueOrderId: _):
            fatalError("NOT IMPLEMENTED YET")
        }
    }
    
    private static func buildUserOrderRequest(_ req: Request.UserOrderRequest)-> DataRequest{
        switch req {
        case .addUserOrder:
            fatalError("NOT IMPLEMENTED YET")
        case .deleteUserOrder(venueOrderId: _):
            fatalError("NOT IMPLEMENTED YET")
        case .deleteUserOrderItem(venueOrderId: _, itemId: _, callBack: _):
            fatalError("NOT IMPLEMENTED YET")
        case .getUserOrders(venueOrderID: let venueOrderID, callBack: _):
            if let voID = venueOrderID{
                let params: Parameters = ["venue_order_id" : voID]
                return alamofireRequest(path: Const.Request.Path.getUserOrdersPath,
                                        parameters: params)
            }
            return alamofireRequest(path: Const.Request.Path.getUserOrdersPath)
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
    
    
}
