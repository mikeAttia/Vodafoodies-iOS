//
//  Logger.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

func printError(_ err: String, title: String = "", file: String = #file, function: String = #function, line: Int = #line) {
    
    print("❌❌❌ " + title + " ❌❌❌")
    print("==================================")
    print("‼️ " + err + " ‼️")
    print("==================================")
    print("📄 File : \(file)")
    print("🔶 Function: \(function)")
    print("➡️ Line: \(line)")
    print("==================================")
}
