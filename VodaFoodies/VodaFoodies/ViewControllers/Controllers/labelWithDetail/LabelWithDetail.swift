//
//  LabelWithDetail.swift
//  VodaFoodies
//
//  Created by Michael Attia on 10/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class LabelWithDetail: UITableViewCell, GradientsOwner{
    
    //View Outlets
    @IBOutlet weak var mainLabel: GradientContainerView!
    @IBOutlet weak var detailLabel: GradientContainerView!
    
    
    var gradientLayers: [CAGradientLayer]{
        setupLayer(views: [mainLabel, detailLabel])
        return [mainLabel.gradientLayer, detailLabel.gradientLayer]
    }
    
}
