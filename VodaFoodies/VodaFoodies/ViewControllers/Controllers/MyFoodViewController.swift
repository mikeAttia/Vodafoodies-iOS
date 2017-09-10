//
//  MyFoodViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class MyFoodViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
   //Constants
    let cellIdentifier = "orderItem"
    let pageTitle = "My Food"
    
    //Instance Variables
    var orders : [UserOrder] = []
    
    //View Outlets
    @IBOutlet weak var contentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup view
        self.title = pageTitle
        
        // Setting up table view
        contentTable.delegate = self
        contentTable.dataSource = self
        contentTable.estimatedRowHeight = 40
        contentTable.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: View Loading indicator
        let req = Request.userOrder(.getUserOrders(venueOrderID: nil, callBack: handleRequestResult))
        DataStore.shared.getData(req: req)
    }
    
    private func handleRequestResult(orders: [UserOrder], err: RequestError?){
        //TODO: hide loading indicator
        if let error = err{
            //Show Error Message to user
            printError(error.error)
            return
        }
        self.orders = orders
        self.contentTable.reloadData()
    }
    
    //MARK: - Table View Delegate
    //Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TableHeaderView ?? TableHeaderView(reuseIdentifier: "header")
        header.venueName.text = orders[section].venue.name
        header.orderStatus.text = orders[section].orderStatus.rawValue
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33.0
    }

    
    //Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MenuItem
        cell?.itemName.text = orders[indexPath.section].items[indexPath.row].item.name
        if orders[indexPath.section].items[indexPath.row].size.lowercased() != "price"{
            cell?.itemPrice.text = orders[indexPath.section].items[indexPath.row].size
        }else{
            cell?.itemPrice.text = ""
        }
        
        return cell!
    }
    
}
