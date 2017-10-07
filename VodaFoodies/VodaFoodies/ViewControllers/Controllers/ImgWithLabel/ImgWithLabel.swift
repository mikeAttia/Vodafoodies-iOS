//
//  ImgWithLabel.swift
//  VodaFoodies
//
//  Created by Michael Attia on 10/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class ImgWithLabel: UITableViewCell, GradientsOwner {
    
    //Outlets
    @IBOutlet weak var imgView: GradientContainerView!
    @IBOutlet weak var titleView: GradientContainerView!
    
    
    var gradientLayers: [CAGradientLayer]{
        setupLayer(views: [imgView, titleView])
        return [imgView.gradientLayer, titleView.gradientLayer]
    }
    
}
