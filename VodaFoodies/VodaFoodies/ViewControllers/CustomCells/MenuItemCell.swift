//
//  MenueItemCell.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    // MARK: - Cell Contents Outlets
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceRangeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
