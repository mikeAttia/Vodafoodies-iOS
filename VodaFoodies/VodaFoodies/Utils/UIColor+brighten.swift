//
//  UIColor+brighten.swift
//  VodaFoodies
//
//  Created by Michael Attia on 10/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

extension UIColor {
    func brightened(by factor: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
    }
}
