//
//  BaseTabBarController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        self.tabBar.tintColor = UIColor.red
        let items = self.tabBar.items
        items?[0].image = #imageLiteral(resourceName: "list")
        items?[1].image = #imageLiteral(resourceName: "food")
        if Const.Global.userGender == "female"{
            items?[2].image = #imageLiteral(resourceName: "female")
        }else{
            items?[2].image = #imageLiteral(resourceName: "male")
        }
    }
   
}
