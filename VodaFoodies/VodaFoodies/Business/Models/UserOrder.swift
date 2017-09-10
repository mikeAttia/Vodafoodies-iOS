//
//  UserOrder.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/10/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

struct UserOrder {
    let venueOrderId: String
    let orderTime: Double
    let orderStatus: OrderStatus
    let venue: Venue
    let admin: User
    let items: [OrderItem]
}

enum OrderStatus: String{
    
    case open
    case cancelled
    case ordered
    case delivered
}
