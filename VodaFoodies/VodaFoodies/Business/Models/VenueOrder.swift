//
//  VenueOrder.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

struct VenueOrder {
    
    enum OrderStatus {
        case open
        case ordered
        case delivered
    }
    
    var venue: Venue
    var respUser: User
    var status: OrderStatus
    var userOrders: [UserOrder]
    var items: (item: MenuItem, sizes: [(size: MenuItem.Size, count: Int)])
        // a computed property from the users orders
}
