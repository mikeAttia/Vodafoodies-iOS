//
//  OpenOrdersViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class OpenOrdersViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Constants
    let cellNibName = "VenueOrderCell"
    let orderCellIdentifier = "orderItem"
    let orderDetailsSegue = "viewOrderDetails"
    let viewTitle = "Open Orders"
    let startAnOrderSegueId = "startAnOrder"
    
    // View Outlets
    @IBOutlet weak var contentTable: UITableView!
    
    // Instance Variables
    var orders: [Order]?
    
    override func viewDidLoad() {
        //View title
        self.title = viewTitle
        
        // Setting up table view
        contentTable.register(UINib(nibName: cellNibName , bundle: nil) , forCellReuseIdentifier: orderCellIdentifier)
        // Setting table placeholder delegate and datasrouce
        contentTable.emptyDataSetSource = self
        contentTable.emptyDataSetDelegate = self
        //Creating and firing temp delegate
        fillTable(contentTable, withTempCell: .openOrderCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contentTable.reloadData()
        DataStore.shared.getData(req: .venueOrder(.getOpenOrders(callBack: handleRequestresult)))
    }
    
    private func handleRequestresult(orders: [Order], err: RequestError?){
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


//MARK: - DZN Empty Datasource and delegate

extension OpenOrdersViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attrs = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 21),
                     NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: "No Orders!", attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "pot")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = NSTextAlignment.center
        let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                     NSForegroundColorAttributeName: UIColor.lightGray,
                     NSParagraphStyleAttributeName: paragraph]
        return NSAttributedString(string: "Looks like no body started any orders yet. \n Be a hero and start one now", attributes: attrs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let attrs = [NSForegroundColorAttributeName: UIColor.red ]
        return NSAttributedString(string: "Start An Order", attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        performSegue(withIdentifier: startAnOrderSegueId, sender: nil)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor(red: 240/255, green: 240/255, blue: 245/255, alpha: 1.0)
    }
}
