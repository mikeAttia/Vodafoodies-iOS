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
    let orderDetailsSegue = "viewOrderDetails"
    let viewTitle = "Open Orders"
    
    // View Outlets
    @IBOutlet weak var contentTable: UITableView!
    
    // Instance Variables
    var orders: [Order]?
    
    override func viewDidLoad() {
        //View title
        self.title = viewTitle
        
        // Setting up table view
        contentTable.register(UINib(nibName: cellNibName , bundle: nil) , forCellReuseIdentifier: orderCellIdentifier)
        //Creating and firing temp delegate
        fillTable(contentTable, withTempCell: .openOrderCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contentTable.reloadData()
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
        fillTable(contentTable, withObject: self)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: orderDetailsSegue, sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == orderDetailsSegue{
            let index = sender as! Int
            let vc = segue.destination as? OrderDetailsViewController
            vc?.order = orders?[index]
        }
        
    }
    
    
}
