//
//  MyFoodViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MyFoodViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
   //Constants
    let cellIdentifier = "orderItem"
    let headerIdentifier = "header"
    let headerNibFileName = "UserOrderHeader"
    let pageTitle = "My Food"
    
    //Instance Variables
    var orders : [Order] = []
    
    //View Outlets
    @IBOutlet weak var contentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup view
        self.title = pageTitle
        
        // Registering Header nib file
        contentTable.register(UINib(nibName: headerNibFileName, bundle: nil) , forHeaderFooterViewReuseIdentifier: headerIdentifier)
        
        // Setting empty set placeholder
        contentTable.emptyDataSetDelegate = self
        contentTable.emptyDataSetSource = self
        
        //Filling table with temp cells
        fillTable(contentTable, withTempCell: .labelWithDetail)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: View Loading indicator
        contentTable.reloadData()
        let req = Request.userOrder(.getUserOrders(venueOrderID: nil, userID: nil, callBack: handleRequestResult))
        DataStore.shared.getData(req: req)
    }
    
    private func handleRequestResult(orders: [Order], err: RequestError?){
        //TODO: hide loading indicator
        if let error = err{
            //Show Error Message to user
            printError(error.error)
            return
        }
        self.orders = orders
        fillTable(contentTable, withObject: self)
    }
    
    private func handleDeletionResult(err: RequestError?){
        
        //TODO: IMPlement methods to delete item
        let req = Request.userOrder(.getUserOrders(venueOrderID: nil, userID: nil, callBack: handleRequestResult))
        DataStore.shared.getData(req: req)
    }
    
    //MARK: - Table View Delegate
    //Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? TableHeaderView
        header?.setupView(venue: orders[section].venue.name,
                          user: orders[section].admin,
                          orderStatus: TagLabel.LabelType(rawValue: orders[section].orderStatus.rawValue)!)
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
        let backGroundView = UIView()
        backGroundView.backgroundColor = UIColor.white
        cell?.selectedBackgroundView = backGroundView
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // guarding that order is open
        guard orders[indexPath.section].orderStatus == .open else{
            print("use can't edit order")
            return
        }
        let order = orders[indexPath.section]
        let item = order.items[indexPath.row]
        let itemsCount = order.items.count
        let isAdmin = Const.Global.userID == orders[indexPath.section].admin.firebaseID
        
        let alertView = UIAlertController(title: item.item.name, message: nil, preferredStyle: .actionSheet)
        
        var request: Request?
        
        if itemsCount < 2 {
            
            if isAdmin{
                let deleteVenueOrder = UIAlertAction(title: "Delete Venue Order", style: .default, handler: {[weak self] _ in
                    request = Request.venueOrder(.deleteVenueOrder(venueOrderId: order.venueOrderId, callBack: self!.handleDeletionResult))
                    DataStore.shared.getData(req: request!)
                    print("Delete Venue Order")
                })
                alertView.addAction(deleteVenueOrder)
            }else{
                let deleteMyOrder = UIAlertAction(title: "Delete My Order", style: .default, handler: {[weak self] _ in
                    request = Request.userOrder(.deleteUserOrder(venueOrderId: order.venueOrderId, callBack: self!.handleDeletionResult))
                    DataStore.shared.getData(req: request!)
                    print("Delete My Order")
                })
                alertView.addAction(deleteMyOrder)
            }
            
        }else{
            
            let deleteItem = UIAlertAction(title: "Delete this item", style: .default, handler: {[weak self] _ in
                request = Request.userOrder(.deleteUserOrderItem(venueOrderId: order.venueOrderId, itemId: item.item.id, itemSize: item.size, callBack: self!.handleDeletionResult))
                DataStore.shared.getData(req: request!)
                print("Delete Item")
            })
            alertView.addAction(deleteItem)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        alertView.addAction(cancel)
        
     self.present(alertView, animated: true, completion: nil)
    }
}

//MARK: - DZN Empty Datasource and delegate

extension MyFoodViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attrs = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 21),
                     NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: "Aren't You hungry?", attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "tasa")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = NSTextAlignment.center
        let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                     NSForegroundColorAttributeName: UIColor.lightGray,
                     NSParagraphStyleAttributeName: paragraph]
        return NSAttributedString(string: "Go ahead and make an order with someone. \rOr start a new order", attributes: attrs)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor(red: 240/255, green: 240/255, blue: 245/255, alpha: 1.0)
    }
}

