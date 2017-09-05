//
//  RequestType.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/31/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

/// An enum carrying the request type and data
enum Request{
    case user(UserRequest)
    case venue(VenueRequest)
    case venueOrder(VenueOrderRequest)
    case userOrder(UserOrderRequest)
    
    enum UserRequest {
        case updateUserData(userData: User,callBack: (_ error: RequestError?)->Void)
    }
    
    enum VenueRequest{
        case listedVenues(callBack: (_ result: [Venue]?,_ error: RequestError?)->Void)
        case venueMenu(venueID: String, callBack: (_ result: [(String, [Item])]?,_ error: RequestError?)->Void)
    }
    
    enum VenueOrderRequest {
        case addVenueOrder(callBack: (_ error: RequestError?)->Void)
        // TODO: Associated value is order object
        case getOpenOrders(callBack: (_ error: RequestError?)->Void)
        // TODO: Parameter in callback for list of open orders
        case getOrderSum(venueOrderId: String, callBack: (_ error: RequestError?)->Void)
        // TODO: Parameter in callback for list order sum
        case getOrderItemUsers(venueOrderId: String, itemId: String, callBack: (_ error: RequestError?)->Void)
        // TODO: Parameter in callback for order items users
        case getVenueOrderUsers(venueOrderId: String, callBack: (_ error: RequestError?)->Void)
        // TODO: Parameter in callback for venue ordre users
    }
    
    enum UserOrderRequest{
        case addUserOrder(callBack: (_ error: RequestError?)->Void)
        // TODO: Associated value is order object
        case getUserOrders(venueOrderID: String?, callBack: (_ error: RequestError?)->Void)
        // TODO: Parameter in callback list of user orders
        case deleteUserOrderItem(venueOrderId: String, itemId: String, callBack: (_ error: RequestError?)->Void)
        case deleteUserOrder(venueOrderId: String, callBack: (_ error: RequestError?)->Void)
    }
}

struct RequestError: Error {
    let error: String
}



