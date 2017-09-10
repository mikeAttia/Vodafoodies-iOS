//
//  OrderHeaderView.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/10/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    
    let venueName = UILabel()
    let orderStatus = UILabel()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Content View
        contentView.backgroundColor = UIColor.clear
        
        let marginGuide = contentView.layoutMarginsGuide
        
        // admin name label
        contentView.addSubview(orderStatus)
        orderStatus.textColor = UIColor.black
        orderStatus.font = UIFont.italicSystemFont(ofSize: 13)
        orderStatus.translatesAutoresizingMaskIntoConstraints = false
//        orderStatus.widthAnchor.constraint(equalToConstant: 12).isActive = true
        orderStatus.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        orderStatus.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        orderStatus.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        // Venue Name label
        contentView.addSubview(venueName)
        venueName.textColor = UIColor.red
        venueName.font = UIFont.systemFont(ofSize: 20, weight: 0.2)
        venueName.translatesAutoresizingMaskIntoConstraints = false
        venueName.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        venueName.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        venueName.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        venueName.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
