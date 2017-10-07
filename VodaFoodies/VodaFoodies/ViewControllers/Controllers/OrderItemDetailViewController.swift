//
//  OrderItemDetailViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 10/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class OrderItemDetailViewController: BaseViewController {
    
    //Constants
    let itemUerCellId = "ItemUserCell"
    
    //View outlets
    @IBOutlet weak var contentTable: UITableView!
    
    // Instance Variables
    var orderItem: OrderItem!
    var venueOrderID : String!
    var usersOrders: [(user: User, size: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // page title
        self.title = orderItem.item.name
        
        // Make the request
        let request = Request.venueOrder(.getOrderItemUsers(venueOrderId: venueOrderID, itemId: orderItem.item.id, callBack: handleRequestResult))
        DataStore.shared.getData(req: request)
        
        //Fill table with temp cells
        fillTable(contentTable, withTempCell: .imgWithLabel)
    }

    func handleRequestResult(orderUsers: [(User, String)], error: RequestError?){
        guard error == nil else{
            printError((error?.error)!)
            return
        }
        self.usersOrders = orderUsers
        fillTable(contentTable, withObject: self)
    }
    
}

extension OrderItemDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemUerCellId) as? ItemUserCell
        cell?.userImg.kf.setImage(with: URL(string: usersOrders[indexPath.row].user.imageURL), placeholder: #imageLiteral(resourceName: "male"))
        cell?.userName.text = usersOrders[indexPath.row].user.name
        if usersOrders[indexPath.row].size.lowercased() != "price"{
            cell?.sizeLabel.isHidden = false
            cell?.sizeLabel.text = usersOrders[indexPath.row].size
        }else{ cell?.sizeLabel.isHidden = true}
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

class ItemUserCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImg.layer.cornerRadius = userImg.frame.height / 2
        userImg.clipsToBounds = true
    }
    
}
