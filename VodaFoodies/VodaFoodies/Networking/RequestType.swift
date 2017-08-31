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
    
    private static let baseURL = ""
    
    /// Use to generate a request object from the type sent
    static func buildRequest(_ req: RequestType)/*should return a request object*/{
        
        switch req {
        case .user(let request):
            buildUserRequest(request)
        case.venue(let request):
            buildVenueRequest(request)
        case .userOrder(let request):
            buildUserOrderRequest(request)
        case .venueOrder(let request):
            buildVenueOrderRequest(request)
        }
        
    }
    
    private static func buildUserRequest(_ req: UserRequest)/*should return a request object*/{
        
        switch req {
        case .updateUserData:// TODO: Associated value is User object
            break
        }
    }
    
    private static func buildVenueRequest(_ req: VenueRequest)/*should return a request object*/{
        
        switch req {
        case .listedVenues: break
        case .venueMenu(venueID: _): break
        }
        
    }
    
    private static func buildVenueOrderRequest(_ req: VenueOrderRequest)/*should return a request object*/{
        switch req {
        case .addVenueOrder:break
        case .getOpenOrders: break
        case .getOrderItemUsers(venueOrderId: _, itemId: _): break
        case .getOrderSum(venueOrderId: _): break
        case .getVenueOrderUsers(venueOrderId: _): break
        }
    }
    
    private static func buildUserOrderRequest(_ req: UserOrderRequest)/*should return a request object*/{
        switch req {
        case .addUserOrder: break
        case .deleteUserOrder(venueOrderId: _): break
        case .deleteUserOrderItem(venueOrderId: _, itemId: _): break
        case .getUserOrders(venueID: _): break
        }
        
    }
}



