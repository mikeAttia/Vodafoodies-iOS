//
//  OpenOrdersViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class OpenOrdersViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Constants
    let cellNibName = "VenueOrderCell"
    let orderCellIdentifier = "orderItem"
    
    // View Outlets
    @IBOutlet weak var contentTable: UITableView!
    
    // Instance Variables
    var orders: [Order]?
    
    override func viewDidLoad() {
        
        // Setting up table view
        contentTable.delegate = self
        contentTable.dataSource = self
        contentTable.estimatedRowHeight = 50
        contentTable.rowHeight = UITableViewAutomaticDimension
        contentTable.register(UINib(nibName: cellNibName , bundle: nil) , forCellReuseIdentifier: orderCellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // TODO: Show the loading indicator
        DataStore.shared.getData(req: .venueOrder(.getOpenOrders(callBack: handleRequestresult)))
    }
    
    private func handleRequestresult(orders: [Order], err: RequestError?){
        // TODO: hide the loading indicator
        guard err == nil else {
            printError((err?.error)!)
            //TODO: Show error message to user
            return
        }
        
        self.orders = orders
        contentTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: orderCellIdentifier) as! VenueOrderCell
        cell.setupView(order: orders![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    
}
