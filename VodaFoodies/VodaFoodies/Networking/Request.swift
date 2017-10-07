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
        case addVenueOrder(venueID: String, time: Double, order: [OrderItem],callBack: (_ error: RequestError?)->Void)
        case getOpenOrders(callBack: (_ order: [Order], _ error: RequestError?)->Void)
        case getOrderSum(venueOrderId: String, callBack: (_ orderItems: [OrderItem], _ error: RequestError?)->Void)
        case getOrderItemUsers(venueOrderId: String, itemId: String, callBack: (_ users: [(User, String)],_ error: RequestError?)->Void)
        case getVenueOrderUsers(venueOrderId: String, callBack: (_ users: [User], _ error: RequestError?)->Void)
        case deleteVenueOrder(venueOrderId: String, callBack: (_ error: RequestError?)->Void)
    }
    
    enum UserOrderRequest{
        case addUserOrder(venueOrderId: String, order: [OrderItem], callBack: (_ error: RequestError?)->Void)
        // TODO: Associated value is order object
        case getUserOrders(venueOrderID: String?,userID: String? , callBack: (_ order: [Order], _ error: RequestError?)->Void)
        case deleteUserOrderItem(venueOrderId: String, itemId: String, itemSize: String, callBack: (_ error: RequestError?)->Void)
        case deleteUserOrder(venueOrderId: String, callBack: (_ error: RequestError?)->Void)
    }
}

struct RequestError: Error {
    let error: String
}



