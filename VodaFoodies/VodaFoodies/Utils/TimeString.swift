//
//  TimeString.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/25/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

func getTimeString(from timeInterval: Double) -> String{
    let orderDate = Date(timeIntervalSince1970: timeInterval)
    let calendar = Calendar.current
    let hours = calendar.component(.hour, from: orderDate) % 12
    let minutes = calendar.component(.minute, from: orderDate)
    let period = calendar.component(.hour, from: orderDate) > 12 ? "PM" : "AM"
    return "\(hours) : \(minutes) \(period)"
}
