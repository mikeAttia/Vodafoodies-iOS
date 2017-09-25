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
    
    // get list of orders
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
    
    // get list of order items
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
                                        size: item["item_size"] as? String ?? "",
                                        count: 1))
        }
        return orderItmes
    }
    
    static func getOrderSumItemsFrom(_ data: Any?)->[OrderItem]{
        guard let data = data as? [String : Any], let json = data["result"] as? [String : Any] else{
            return []
        }
        let itemsKeys = json.keys
        var orderItems: [OrderItem] = []
        for key in itemsKeys{
            let itemData = json[key] as? [String: Any]
            let sizes = itemData?["sizes"] as? [String : [String: Int]]
            let sizesKeys = sizes?.keys
            if let keys = sizesKeys{
                for sizeKey in keys{
                    let size = [ sizeKey : sizes?[sizeKey]?["price"] ?? 0]
                    let item = Item(id: key,
                                    name: itemData?["name"] as? String ?? "",
                                    category: itemData?["category"] as? String ?? "",
                                    sizes: size)
                    orderItems.append(OrderItem(item: item,
                                                size: sizeKey,
                                                count: sizes?[sizeKey]?["count"] ?? 1))
                }
            
            }
        }
        return orderItems
    }
    
    // Getting users data
    static func getListOfUsersFrom(_ data: Any?) -> [User]{
        guard let data = data as? [String: Any], let json = data["result"] as? [[String: Any]]  else{
            return []
        }
        var usersList = [User]()
        for user in json{
            usersList.append(getUserDataFrom(user))
        }
        return usersList
    }
    
    static func getOrderItemUsersFrom(_ data: Any?)->[(User, String)]{
        guard let result = data as? [String: Any], let json = result["result"] as? [[String: Any]] else{
            return []
        }
        var list: [(User, String)] = []
        for item in json{
            let size = item["size"] as? String ?? ""
            let user = getUserDataFrom(item["user"])
            list.append((user, size))
        }
        return list
    }
    
    // get user data
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
