//
//  ResponseParser.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/31/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

/// A class with static methods to parse network response to the app models

class ResponseParser {
    
    /// Get list of venues from json
    static func getVenuesFrom(_ data: Any?)->[Venue]?{
        guard let data = data, let json = data as? [String: Any] else{
            return nil
        }
        var venuesList: [Venue] = []
        
        let ids = json.keys
        for id in ids{
            if let item = json[id] as? [String: String], let name = item["name"], let img = item["img"]{
                venuesList.append(Venue(id: id, name: name, img: img, phones: []))
            }
        }
        return venuesList
    }
    
    /// Get list of tuples containing categories and related items
    static func getMenuFrom(_ data: Any?)->[(String, [Item])]?{
        guard let data = data, let json = data as? [String : Any] else{
            return nil
        }
        var menu: [(String, [Item])] = []
        
        let categories = json.keys
        for category in categories{
            if let cat = json[category] as? [String : Any] {
                menu.append((category , getItemsFrom(cat["items"])))
            }
        }
        return menu
    }
    
    /// get list of items from json
    static func getItemsFrom(_ data: Any?)->[Item]{
        guard let data = data, let json = data as? [String: Any] else{
            return []
        }
        var items: [Item] = []
        
        let ids = json.keys
        for id in ids{
            if let item = json[id] as? [String : Any],
                let category = item["category"] as? String,
                let name = item["name"] as? String,
                let sizes = item["prices"] as? [String : Int]{
                
                items.append(Item(id: id, name: name, category: category, sizes: sizes))
            }
        }
        
        return items
        
    }
}
