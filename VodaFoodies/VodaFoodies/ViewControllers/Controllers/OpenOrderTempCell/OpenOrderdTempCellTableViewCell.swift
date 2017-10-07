//
//  OpenOrderdTempCellTableViewCell.swift
//  VodaFoodies
//
//  Created by Michael Attia on 10/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class OpenOrderdTempCellTableViewCell: UITableViewCell, GradientsOwner {
    
    //Outlets
    @IBOutlet weak var imgPlaceholder: GradientContainerView!
    @IBOutlet weak var tagPlaceHolder: GradientContainerView!
    @IBOutlet weak var venueNamePlaceholder: GradientContainerView!
    @IBOutlet weak var orderAdminPlaceholder: GradientContainerView!
    @IBOutlet weak var adminImgPlaceholder: GradientContainerView!
    @IBOutlet weak var adminNamePlaceholder: GradientContainerView!
    @IBOutlet weak var timePlaceholder: GradientContainerView!
    
    
    var gradientLayers: [CAGradientLayer]{
        
        setupLayer(views: [imgPlaceholder,
                           tagPlaceHolder,
                           venueNamePlaceholder,
                           orderAdminPlaceholder,
                           adminNamePlaceholder,
                           timePlaceholder])
        setupLayer(views: [adminImgPlaceholder], circle: true)
        
        return [imgPlaceholder.gradientLayer,
        tagPlaceHolder.gradientLayer,
        venueNamePlaceholder.gradientLayer,
        orderAdminPlaceholder.gradientLayer,
        adminImgPlaceholder.gradientLayer,
        adminNamePlaceholder.gradientLayer,
        timePlaceholder.gradientLayer]
    }
}
