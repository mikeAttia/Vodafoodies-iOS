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
        case .getOpenOrders(callBack: _):
            return alamofireRequest(path: Const.Request.Path.getOpenOrdersPath)
        case .getOrderItemUsers(venueOrderId: let venueOrderId, itemId: let itemId, callBack: _):
            let params: Parameters = ["venue_order_id" : venueOrderId, "item_id" : itemId]
            return alamofireRequest(path: Const.Request.Path.getOrderItemUsersPath, method: .get, parameters: params)
        case .getOrderSum(venueOrderId: let venueOrderId, callBack: _):
            let params: Parameters = ["venue_order_id" : venueOrderId]
            return alamofireRequest(path: Const.Request.Path.getOrderSumPath,
                                    method: .get,
                                    parameters: params)
        case .getVenueOrderUsers(venueOrderId: let venueOrderID, callBack: _):
            let params: Parameters = ["venue_order_id" : venueOrderID]
            return alamofireRequest(path: Const.Request.Path.getVenueOrderUsersPath,
                             method: .get, parameters: params)
        case .deleteVenueOrder(venueOrderId: let veneuOrderId, callBack: _):
            let params: Parameters = ["venue_order_id" : veneuOrderId]
            return alamofireRequest(path: Const.Request.Path.deleteVenueOrderPath, method: .delete, parameters: params)
        }
    }
    
    private static func buildUserOrderRequest(_ req: Request.UserOrderRequest)-> DataRequest{
        switch req {
        case .addUserOrder(venueOrderId: let venueOrderId, order: let order, callBack: _):
            let params: Parameters = ["venue_order_id" : venueOrderId,
                                      "order_items" : orderItemsList(items: order) ]
            return alamofireRequest(path: Const.Request.Path.addUserOrderPath, method: .post, parameters: params)
        case .deleteUserOrder(venueOrderId: let venueOrderId, callBack: _):
            let params: Parameters = ["venue_order_id" : venueOrderId]
            return alamofireRequest(path: Const.Request.Path.deleteUserOrderPath, method: .delete, parameters: params)
        case .deleteUserOrderItem(venueOrderId: let venueOrderId, itemId: let itemId ,itemSize: let ItemSize, callBack: _):
            let params: Parameters = ["venue_order_id": venueOrderId,
                                      "item_id" : itemId,
                                      "item_size" : ItemSize]
            return alamofireRequest(path: Const.Request.Path.deleteUserOrderItemPath, method: .delete, parameters: params)
        case .getUserOrders(venueOrderID: let venueOrderID,userID: let userId, callBack: _):
            if let voID = venueOrderID{
                var params: Parameters = ["venue_order_id" : voID]
                if let userId = userId{
                    params["user_id"] = userId
                }
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
            encoding = URLEncoding.queryString
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
