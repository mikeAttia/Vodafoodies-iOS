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
        case .addVenueOrder(venueID: let venueId,time: let time, order: let orderItems, callBack: _):
            
            return alamofireRequest(path: Const.Request.Path.addVenueOrderPath,
                                    method: .post,
                                    parameters: self.venueOrderParameters(vid: venueId,time: time, items: orderItems))
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
    
    private static func alamofireRequest(path: String, method: HTTPMethod = .get, parameters: Parameters? = nil) -> DataRequest{
        let headers = [Const.Request.Keys.userId : Const.Global.userID]
        let encoding: ParameterEncoding?
        switch method {
        case .post:
            encoding = JSONEncoding.default
        case .get:
            encoding = URLEncoding.methodDependent
        default:
            encoding = URLEncoding.methodDependent
        }
        return Alamofire.request(Const.Request.Path.baseURL + path,
                          method: method,
                          parameters: parameters,
                          encoding: encoding!,
                          headers: headers)
    }
    
    private static func venueOrderParameters(vid: String, time: Double, items: [OrderItem]) -> Parameters{
        var dict: Parameters = [:]
        dict["venue_id"] = vid
        dict["order_time"] = Int(time)
        dict["order_items"] = orderItemsList(items: items)
        return dict
    }
    
    private static func orderItemsList(items: [OrderItem]) -> [Parameters]{
        var list: [Parameters] = []
        for item in items{
            var listItem: Parameters = [:]
            listItem["item_id"] = item.item.id
            listItem["item_size"] = item.size
            listItem["category"] = item.item.category
            listItem["name"] = item.item.name
            listItem["price"] = item.item.sizes[item.size]!
            list.append(listItem)
        }
        return list
    }
    
    
}
