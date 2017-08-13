//
//  OpenOrderCell.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class OpenOrderCell: UITableViewCell {
    
    // MARK: - Cell Contents Outlets
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var respUserImage: UIImageView!
    @IBOutlet weak var respUserNameLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
