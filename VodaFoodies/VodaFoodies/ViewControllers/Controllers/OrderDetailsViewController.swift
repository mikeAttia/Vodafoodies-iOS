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
    
    // View Outlets
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var tagLabel: TagLabel!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var adminImage: UIImageView!
    @IBOutlet weak var adminNameButton: UIButton!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentTable: UITableView!
    
    // Instance Properties
    var order: Order!
    var usersList: [User]?
    var orderItemsList: [OrderItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup the table view
        contentTable.delegate = self
        contentTable.dataSource = self
        contentTable.estimatedRowHeight = 50
        contentTable.rowHeight = UITableViewAutomaticDimension
        setupView()
    }
    
    func setupView(){
        venueImage.kf.setImage(with: URL(string: order.venue.img))
        tagLabel.setLabelType(TagLabel.LabelType(rawValue: order.orderStatus.rawValue)!)
        venueName.text = order.venue.name
        adminImage.kf.setImage(with: URL(string: order.admin.imageURL))
        adminNameButton.setTitle(order.admin.name, for: .normal)
        orderTimeLabel.text = getTimeString(from: order.orderTime)
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
        }else if segmentedControl.selectedSegmentIndex == peopleIndex{
            DataStore.shared.getData(req: usersRequest)
            print(usersRequest)
        }
    }
    
    private func handleUsersResponse(usersList: [User], error: RequestError?){
        guard error == nil else{
            printError(error!.error)
            return
        }
        print(usersList)
        self.usersList = usersList
        self.contentTable.reloadData()
    }
    
    private func handleOrederSumResponse(orderItems: [OrderItem], error: RequestError?){
        guard error == nil else{
            printError(error!.error)
            return
        }
        self.orderItemsList = orderItems
        self.contentTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // View Actions
    @IBAction func updateTable(_ sender: UISegmentedControl) {
        sendViewRequest()
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
                if item.size.lowercased() != "price"{itemNameSize += " (\(item.size)"}
                cell?.itemNameSizeLabel.text = itemNameSize
                cell?.itemCountLabel.text = "\(item.count)"
                return cell!
            }
        }else if segmentedControl.selectedSegmentIndex == peopleIndex{
            if let users = usersList{
                let user = users[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: userCellId) as? OrderUserCell
                cell?.userNameLabel.text = user.name
                cell?.userImage.kf.setImage(with: URL(string: user.imageURL), placeholder: #imageLiteral(resourceName: "male"))
                return cell!
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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
