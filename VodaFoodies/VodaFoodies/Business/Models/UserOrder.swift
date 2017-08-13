//
//  UserOrder.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

struct UserOrder {
    
    var venue: Venue
    var items: [
    (item: MenuItem,
    variations: [(size: MenuItem.Size, count: Int)])
    ]
    
}
