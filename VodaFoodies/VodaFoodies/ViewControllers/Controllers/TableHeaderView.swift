//
//  OrderHeaderView.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/10/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    
    //View outlets
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var orderStatusTag: TagLabel!
    @IBOutlet weak var adminNameBtn: UIButton!
    
    func setupView(venue: String, user: User, orderStatus: TagLabel.LabelType) {
        self.venueNameLabel.text = venue
        self.adminNameBtn.setTitle(user.name, for: .normal)
        self.orderStatusTag.setLabelType(orderStatus)
        self.contentView.backgroundColor = UIColor.clear
    }
}
