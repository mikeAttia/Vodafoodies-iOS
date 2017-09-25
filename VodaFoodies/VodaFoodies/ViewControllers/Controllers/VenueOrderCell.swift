//
//  VenueOrderCell.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/13/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class VenueOrderCell: UITableViewCell {
    
    //View Outlets
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var tagLabel: TagLabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var adminImage: UIImageView!
    @IBOutlet weak var adminName: UIButton!
    
    //Instance Variables
    var admin: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(order: Order) {
        self.admin = order.admin
        // Adding data to the cell
        venueImage.kf.setImage(with: URL(string: order.venue.img) ,
                               placeholder: #imageLiteral(resourceName: "venue"), options: nil,
                               progressBlock: nil,
                               completionHandler: nil)
        tagLabel.setLabelType(TagLabel.LabelType(rawValue: order.orderStatus.rawValue)!)
        venueName.text = order.venue.name
        adminName.setTitle(order.admin.name, for: .normal)
        adminImage.kf.setImage(with: URL(string: order.admin.imageURL),
                               placeholder: #imageLiteral(resourceName: "male"),
                               options: nil,
                               progressBlock: nil,
                               completionHandler: nil)
        adminImage.layer.cornerRadius = adminImage.frame.height / 2
        
        // Calculating the time to show on the screen
        orderTime.text = getTimeString(from: order.orderTime)
        
        // Configuring the view
        self.accessoryType = .disclosureIndicator
        adminImage.clipsToBounds = true
        adminImage.layer.cornerRadius = adminImage.frame.height / 2
        venueImage.clipsToBounds = true
        venueImage.layer.cornerRadius = 5
        venueImage.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        venueImage.layer.borderWidth = 1
        
    }
    
    @IBAction func showAdminProfile(_ sender: Any) {
        
    }
}
