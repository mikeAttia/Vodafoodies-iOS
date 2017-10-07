//
//  TempViewSetup.swift
//  VodaFoodies
//
//  Created by Michael Attia on 10/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation

func setupLayer(views: [GradientContainerView], circle: Bool = false){
    for view in views{
        view.gradientLayer.masksToBounds = true
        if circle{view.gradientLayer.cornerRadius = view.frame.height/2}
        else{view.gradientLayer.cornerRadius = 3}
    }
}
