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
        guard let json = data as? [String: Any] else{
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
        guard let json = data as? [String : Any] else{
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
        guard let json = data as? [String: Any] else{
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
    
    static func getOrdersFrom(_ data: Any?) -> [Order]{
        guard let result = data as? [String: Any], let json = result["result"] as? [[String: Any]] else{
            return []
        }
        var userOrders: [Order] = []
        for order in json{
            userOrders.append(Order(venueOrderId: order["venue_order_id"] as? String ?? "",
                                        orderTime: order["order_time"] as? Double ?? Date().timeIntervalSince1970,
                                        orderStatus: OrderStatus(rawValue: order["order_status"] as? String ?? "cancelled")!,
                                        venue: Venue(id: order["venue_id"] as? String ?? "",
                                                     name: order["venue_name"] as? String ?? "",
                                                     img: order["venue_image"] as? String ?? "",
                                                     phones: order["venue_phones"] as? [String] ?? []),
                                        admin: getUserDataFrom(order["owner"]),
                                        items: getOrderItemsFrom(order["items"])))
        }
        
        return userOrders
    }
    
    static func getOrderItemsFrom(_ data: Any?) -> [OrderItem]{
        guard let json = data as? [[String: Any]] else {
            return []
        }
        var orderItmes: [OrderItem] = []
        for item in json{
            orderItmes.append(OrderItem(item: Item(id: item["item_id"] as? String ?? "",
                                                   name: item["name"] as? String ?? "",
                                                   category: item["category"] as? String ?? "",
                                                   sizes: [item["item_size"] as? String ?? "" : item["price"] as? Int ?? 0] ),
                                        size: item["item_size"] as? String ?? ""))
        }
        return orderItmes
    }
    
    static func getUserDataFrom(_ data: Any?) -> User{
        guard let json = data as? [String : String] else{
            return User(firebaseID: "", name: "", imageURL: "", phoneNo: "", email: "", profile: "")
        }
        return User(firebaseID: json["id"] ?? "",
                    name: json["name"] ?? "",
                    imageURL: json["image"] ?? "",
                    phoneNo: json["phone"] ?? "",
                    email: json["email"] ?? "",
                    profile: json["profile"] ?? "")
    }
}
