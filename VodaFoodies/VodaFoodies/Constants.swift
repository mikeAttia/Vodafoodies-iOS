//
//  Constants.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/31/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

struct Const {
    
    /// Global Constants
    struct Global {
        //User ID
        private static var _userID: String? = nil
        static var userID: String{
            set{
                _userID = newValue
                UserDefaults.standard.set(newValue, forKey: "UID")
            }
            get{
                if let uid = _userID{
                    return uid
                }
                _userID = UserDefaults.standard.string(forKey: "UID") ?? ""
                return _userID!
            }
        }
        
        private static var _loggedInUser: User? = nil
        static var loggedInUser: User{
            set{
                _loggedInUser = newValue
                UserDefaults.standard.set(newValue.toDict(), forKey: "userData")
            }
            get{
                if let user = _loggedInUser{
                    return user
                }
                if let data =  UserDefaults.standard.dictionary(forKey: "userData") as? [String : String]{
                    _loggedInUser = User.fromDict(data)
                    return _loggedInUser!
                }
                return User(firebaseID: "", name: "", imageURL: "", phoneNo: "", email: "", profile: "")
            }
        }
        
        //User Gender
        private static var _userGender: String? = nil
        static var userGender: String{
            set{
                _userGender = newValue
                UserDefaults.standard.set(newValue, forKey: "ugender")
            }
            get{
                if let gender = _userGender{
                    return gender
                }
                _userGender = UserDefaults.standard.string(forKey: "ugender") ?? ""
                return _userGender!
            }
        }
        
        //User Data
        
        
    }
    
    
    
    /// The constants of Requests
    struct Request {
        
        struct Keys {
            static let userId = "uid"
        }
        
        struct Path{
            //Base url
//            static let baseURL = "http://localhost:5000/vodafoodies-e3f2f/us-central1"
            static let baseURL = "https://us-central1-vodafoodies-e3f2f.cloudfunctions.net"
            
            //user requests
            static let updateUserDataPath = "/updateUserData"
            
            //Venue requests
            static let listedVenuesPath = "/listedVenues"
            static let venueMenuPath = "/getVenueMenu"
            
            //Venue orders requests
            static let addVenueOrderPath = "/addVenueOrder"
            static let getOpenOrdersPath = "/getOpenOrders"
            static let getOrderSumPath = "/getOrderSum"
            static let getOrderItemUsersPath = "/getOrderItemUsers"
            static let getVenueOrderUsersPath = "/getVenueOrderUsers"
            static let deleteVenueOrderPath = "/deleteVenueOrder"
            
            //User orders requests
            static let addUserOrderPath = "/addUserOrder"
            static let getUserOrdersPath = "/getUserOrders"
            static let deleteUserOrderItemPath = "/deleteUserOrderItem"
            static let deleteUserOrderPath = "/deleteUserOrder"
        }
        
    }
}
