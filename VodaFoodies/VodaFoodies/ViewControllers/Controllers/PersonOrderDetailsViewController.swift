//
//  PersonOrderDetailsViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 10/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class PersonOrderDetailsViewController: BaseViewController {
    
    //Constants
    let orderItemCellId = "orderItemCell"
    let totalCellId = "totalCell"
    
    //View Outlets
    @IBOutlet weak var contentTable: UITableView!
    
    
    // Instance Variables
    var user: User!
    var venueOrderID : String!
    var items: [OrderItem] = []
    var total = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup header
        self.title = user.name
        
        //filling table with temp cells
        fillTable(contentTable, withTempCell: .labelWithDetail)
        
        // Firing the request to get the view data
        let request = Request.userOrder(.getUserOrders(venueOrderID: venueOrderID, userID: user.firebaseID, callBack: handleRequestResult))
        DataStore.shared.getData(req: request)
    }
    
    func handleRequestResult(order: [Order], error: RequestError?){
        guard error == nil else{
            return
        }
        if order.count > 0{items = order[0].items}
        // getting the total of the order
        total = items.reduce(0, { $0.1.item.sizes[$0.1.size] ?? 0 * $0.1.count})
        
        //reloading the table
        fillTable(contentTable, withObject: self)
    }

}

extension PersonOrderDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count > 0{
            return items.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < items.count{
            let item = items[indexPath.row].item
            let size = items[indexPath.row].size
            let cell = tableView.dequeueReusableCell(withIdentifier: orderItemCellId) as? ItemCell
            var title = item.name
            if size.lowercased() != "price"{
                title.append(" (\(size))")
            }
            cell?.titleLabel.text = title
            
            if let price = item.sizes[size]{
                cell?.detailLabel.text = "\(price) EGP"
            }
            return cell!
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: totalCellId) as? TotalCell
            cell?.totalLabel.text = "\(total) EGP"
            return cell!
        }
    }
}

class TotalCell: UITableViewCell {
    @IBOutlet weak var totalLabel: UILabel!
}

class ItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
}


