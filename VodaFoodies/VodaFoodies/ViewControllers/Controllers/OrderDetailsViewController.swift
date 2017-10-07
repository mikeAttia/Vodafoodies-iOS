//
//  OrderDetailsViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/19/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class OrderDetailsViewController: BaseViewController {
    
    // Constants
    let orderIndex = 0
    let peopleIndex = 1
    let userCellId = "UserCell"
    let ordetItemCellId = "orderItemCell"
    let showOrderItemDetailSegueId = "showOrderItemDetails"
    let showPersonOrderDetailsSegueId = "showPersonOrderDetails"
    let veneuMenuSegueId = "openVenueMenu"
    
    // View Outlets
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var tagLabel: TagLabel!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var adminImage: UIImageView!
    @IBOutlet weak var adminNameButton: UIButton!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentTable: UITableView!
    @IBOutlet weak var tapTipLabel: UILabel!
    @IBOutlet weak var phone1Lable: UILabel!
    @IBOutlet weak var phone2Label: UILabel!
    @IBOutlet weak var phone3Label: UILabel!
    @IBOutlet weak var phoneSeparator1Label: UILabel!
    @IBOutlet weak var phoneSeparator2Label: UILabel!
    
    // Instance Properties
    var order: Order!
    var usersList: [User]?
    var orderItemsList: [OrderItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupStatusTag()
    }
    
    func setupView(){
        venueImage.kf.setImage(with: URL(string: order.venue.img))
        venueName.text = order.venue.name
        adminImage.kf.setImage(with: URL(string: order.admin.imageURL))
        adminNameButton.setTitle(order.admin.name, for: .normal)
        orderTimeLabel.text = getTimeString(from: order.orderTime)
        
        func setupPhoneLabel(label: UILabel, text: String){
            //TODO: Change the color of the label to indicate it's clickable
            label.text = text
            label.isHidden = false
            label.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(callVenue(_:)))
            label.addGestureRecognizer(gesture)
        }
        
        let phones = order.venue.phones
        if phones.count > 0{
            setupPhoneLabel(label: phone1Lable, text: phones[0])
        }
        if phones.count > 1{
            setupPhoneLabel(label: phone2Label, text: phones[1])
            phoneSeparator1Label.isHidden = false
        }
        if phones.count > 2{
           setupPhoneLabel(label: phone3Label, text: phones[2])
            phoneSeparator2Label.isHidden = false
        }
    }
    
    func setupStatusTag(){
        tagLabel.setLabelType(TagLabel.LabelType(rawValue: order.orderStatus.rawValue)!)
        tagLabel.layer.cornerRadius = 3
        tagLabel.clipsToBounds = true
        // Enable changing status if admin
        if order.admin.firebaseID == Const.Global.userID{
            tapTipLabel.isHidden = false
            let gesture = UITapGestureRecognizer(target: self, action: #selector(changeOrderStatus(_:)))
            tagLabel.addGestureRecognizer(gesture)
            tagLabel.isUserInteractionEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sendViewRequest()
    }
    
    func sendViewRequest(){
        //TODO: Add the loading cells to the table view if empty
        let usersRequest = Request.venueOrder(.getVenueOrderUsers(venueOrderId: order.venueOrderId, callBack: handleUsersResponse))
        let itemsRequest = Request.venueOrder(.getOrderSum(venueOrderId: order.venueOrderId, callBack: handleOrederSumResponse))
        
        if segmentedControl.selectedSegmentIndex == orderIndex{
            DataStore.shared.getData(req: itemsRequest)
            if orderItemsList == nil{
                fillTable(contentTable, withTempCell: .labelWithDetail)
            }else{
                fillTable(contentTable, withObject: self)
            }
        }else if segmentedControl.selectedSegmentIndex == peopleIndex{
            DataStore.shared.getData(req: usersRequest)
            if usersList == nil{
                fillTable(contentTable, withTempCell: .imgWithLabel)
            }else{
                fillTable(contentTable, withObject: self)
            }
        }
    }
    
    private func handleUsersResponse(usersList: [User], error: RequestError?){
        guard error == nil else{
            printError(error!.error)
            return
        }
        print(usersList)
        self.usersList = usersList
        fillTable(contentTable, withObject: self)
    }
    
    private func handleOrederSumResponse(orderItems: [OrderItem], error: RequestError?){
        guard error == nil else{
            printError(error!.error)
            return
        }
        self.orderItemsList = orderItems
        fillTable(contentTable, withObject: self)
    }

    // View Actions
    @IBAction func updateTable(_ sender: UISegmentedControl) {
        sendViewRequest()
    }
    
    func callVenue(_ sender: UITapGestureRecognizer){
        if let phoneLabel = sender.view as? UILabel{
            //TODO: Call the restaurant using the label text
            print(phoneLabel.text)
        }
    }
    
    func changeOrderStatus(_ sender: UITapGestureRecognizer){
        //TODO: start the dialogue to change order status
        print("Change order status clicked")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showOrderItemDetailSegueId{
            if let vc = segue.destination as? OrderItemDetailViewController, let data = sender as? [String: Any]{
                vc.orderItem = data["orderItem"] as! OrderItem
                vc.venueOrderID = data["orderID"] as! String
            }
            
        }else if segue.identifier == showPersonOrderDetailsSegueId{
            if let vc = segue.destination as? PersonOrderDetailsViewController, let data = sender as? [String: Any]{
                vc.venueOrderID = data["orderID"] as! String
                vc.user = data["user"] as! User
            }
        }else if segue.identifier == veneuMenuSegueId{
            if let vc = segue.destination as? MenuViewController{
                vc.hidesBottomBarWhenPushed = true
                vc.owner = false
                vc.venue = order.venue
                vc.venueOrderId = order.venueOrderId
            }
        }
    }
    
}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == orderIndex{
            return orderItemsList?.count ?? 0
        }else if segmentedControl.selectedSegmentIndex == peopleIndex{
            return usersList?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == orderIndex{
            if let items = orderItemsList{
                let item = items[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: ordetItemCellId) as? OrderItemCell
                var itemNameSize = item.item.name
                if item.size.lowercased() != "price"{itemNameSize += " (\(item.size))"}
                cell?.itemNameSizeLabel.text = itemNameSize
                cell?.itemCountLabel.text = "\(item.count)"
                cell?.selectionStyle = .none
                return cell!
            }
        }else if segmentedControl.selectedSegmentIndex == peopleIndex{
            if let users = usersList{
                let user = users[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: userCellId) as? OrderUserCell
                cell?.userNameLabel.text = user.name
                cell?.userImage.kf.setImage(with: URL(string: user.imageURL), placeholder: #imageLiteral(resourceName: "male"))
                cell?.selectionStyle = .none
                return cell!
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == orderIndex{
            if let items = orderItemsList{
                var data = [String: Any]()
                data["orderID"] = order.venueOrderId
                data["orderItem"] = items[indexPath.row]
               performSegue(withIdentifier: showOrderItemDetailSegueId, sender: data)
            }
        }else if segmentedControl.selectedSegmentIndex == peopleIndex{
            if let users = usersList{
                var data = [String: Any]()
                data["orderID"] = order.venueOrderId
                data["user"] = users[indexPath.row]
               performSegue(withIdentifier: showPersonOrderDetailsSegueId, sender: data)
            }
        }
    }
    
}

class OrderItemCell: UITableViewCell {
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var itemNameSizeLabel: UILabel!
}

class OrderUserCell: UITableViewCell{
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
}
