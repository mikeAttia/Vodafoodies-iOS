//
//  User.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

struct User {
    var firebaseID: String
    var name: String
    var imageURL: String
    var phoneNo: String
    var email: String
    var profile: String
    
    func toDict() -> [String: String]{
        var dict: [String: String] = [:]
        dict["firebaseID"] = firebaseID
        dict["name"] = name
        dict["imageURL"] = imageURL
        dict["phoneNo"] = phoneNo
        dict["email"] = email
        dict["profile"] = profile
        return dict
    }
    
    static func fromDict(_ dict: [String: String]) -> User{
        return User(firebaseID: dict["firebaseID"] ?? "",
                    name: dict["name"] ?? "",
                    imageURL: dict["imageURL"] ?? "",
                    phoneNo: dict["phoneNo"] ?? "",
                    email: dict["email"] ?? "",
                    profile: dict["profile"] ?? "")
    }
}
