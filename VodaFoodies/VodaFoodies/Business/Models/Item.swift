//
//  Item.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

struct Item {
    let id: String
    let name: String
    let category: String
    let sizes: [String: Int]
}

struct OrderItem{
    let item: Item
    let size: String
}
