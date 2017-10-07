//
//  ConfirmOrderViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/9/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    //Constants
    let itemCellIdentifier = "orderItem"
    let totalCellIdentifier = "totalCell"
    let cellHeight = 44
    let totalCellHeight: CGFloat = 50
    
    // Instance variables
    var venue: Venue?
    var venueOrderId: String?
    var orderItems: [OrderItem]?
    var owner = false
    
    // View Outlets
    @IBOutlet weak var contentTable: UITableView!
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up view
        headerImg.image = headerImg.image!.withRenderingMode(.alwaysTemplate)
        headerImg.tintColor = UIColor.red
        if !owner {
            datePickerHeight.constant = 0
            datePickerView.isHidden = true
        }else{
            let now = Date()
            let calendar = Calendar.current
            datePicker.date =  calendar.date(byAdding: .minute, value: 5, to: now)!
            datePicker.minimumDate = calendar.date(byAdding: .minute, value: 5, to: now)
            
            let gregorian = Calendar(identifier: .gregorian)
            var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
            components.hour = 22
            components.minute = 0
            components.second = 0
            
            datePicker.maximumDate = gregorian.date(from: components)!
        }
        
        // Setting up table view
        contentTable.delegate = self
        contentTable.dataSource = self
        contentTable.estimatedRowHeight = 50
        contentTable.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableHeight.constant = CGFloat(orderItems!.count * cellHeight) + totalCellHeight
    }
    
    //MARK: - View Actions
    
    @IBAction func PlaceOrder(_ sender: Any) {
        // TODO: View the loading indicator
        if !owner{
            if let venueOrderId = venueOrderId, let orderItems = orderItems{
                let request = Request.userOrder(.addUserOrder(venueOrderId: venueOrderId, order: orderItems, callBack: handleRequestResult))
                DataStore.shared.getData(req: request)
            }
            
        }else{
            let timeInterval = datePicker.date.timeIntervalSince1970
            DataStore.shared.getData(req: .venueOrder(.addVenueOrder(venueID: self.venue!.id,
                                                                     time: timeInterval,
                                                                     order: self.orderItems!,
                                                                     callBack: handleRequestResult)))
        }
       
    }
    
    private func handleRequestResult(_ err: RequestError?){
        
        //TODO: Dismiss the loading indicator
        guard let error = err else{
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
            // Show success message
            return
        }
        // TODO: View dialouge to the user
        printError(error.error, title: "making venue Order")
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems!.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < (orderItems?.count)!{
            let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier) as! MenuItem
            let item = orderItems?[indexPath.row]
            cell.itemName.text = item?.item.name
            if let price = item!.item.sizes[(item!.size)]{
                cell.itemPrice.text = "\(price) EGP"
            }
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: totalCellIdentifier) as! TotalPriceCell
            var total = 0
            for item in orderItems!{
                total += item.item.sizes[item.size]!
            }
            cell.priceLabel.text = "\(total) EGP"
            return cell
        }
        
    }
}

//MARK: - Total Price Cell

class TotalPriceCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    
}
