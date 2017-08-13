//
//  MenuItem.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

struct MenuItem {
    
    enum Size {
        case medium(price: Float)
        case Large(price: Float)
    }
    
    var id: String
    var name: String
    var sizes:[Size]
    
}

