//
//  RequestType.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/31/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation
import Alamofire

/// An enum carrying the request type and data
enum RequestType{
    case user(UserRequest)
    case venue(VenueRequest)
    case venueOrder(VenueOrderRequest)
    case userOrder(UserOrderRequest)
    
    enum UserRequest {
        case updateUserData // TODO: Associated value is User object
    }
    
    enum VenueRequest{
        case listedVenues
        case venueMenu(venueID: String)
    }
    
    enum VenueOrderRequest {
        case addVenueOrder // TODO: Associated value is order object
        case getOpenOrders
        case getOrderSum(venueOrderId: String)
        case getOrderItemUsers(venueOrderId: String, itemId: String)
        case getVenueOrderUsers(venueOrderId: String)
    }
    
    enum UserOrderRequest{
        case addUserOrder // TODO: Associated value is order object
        case getUserOrders(venueID: String?)
        case deleteUserOrderItem(venueOrderId: String, itemId: String)
        case deleteUserOrder(venueOrderId: String)
    }
}



