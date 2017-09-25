//
//  MenuViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/8/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Constants
    let pageTitle = "Menu"
    let cellIdentifier = "menuItem"
    let confirmSegueID = "confirmOrder"
    
    //Instance variables
    var venue: Venue?
    var menu: [(label: String, items: [Item])]?
    var selectedCategoryIndex: Int?
    var selectedIndexes: [IndexPath] = []
    var orderItems : [OrderItem] = []{
        didSet{
            if orderItems.count > 0{
                doneBtn.isEnabled = true
            }
            else{
                doneBtn.isEnabled = false
            }
        }
    }
    var owner = false
    
    //View Outlets
    @IBOutlet weak var contentTable: UITableView!
    @IBOutlet weak var venueLogo: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up view
        self.title = pageTitle
        doneBtn.isEnabled = false
        
        // Setting up table view
        contentTable.delegate = self
        contentTable.dataSource = self
        contentTable.estimatedRowHeight = 50
        contentTable.rowHeight = UITableViewAutomaticDimension
        
        // Filling venue data
        venueLogo.kf.setImage(with: URL(string: venue!.img))
        venueNameLabel.text = venue!.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: View loading indicator and get data
        if let venueID = venue?.id{
            let req = Request.venue(.venueMenu(venueID: venueID, callBack: handleRequestResult))
            DataStore.shared.getData(req: req)
        }
    }
    
    func handleRequestResult(menu: [(String, [Item])]?, err: RequestError?){
        
        //TODO: Dismiss the loading indicator
        
        guard let venueMenu = menu else{
            if let error = err{
                // TODO: Show Error message to the user
                print(error.error)
            }
            return
        }
        
        self.menu = venueMenu
        contentTable.reloadData()
    }
    
    //MARK: - Table View Delegate
    
    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        header.delegate = self
        header.titleLabel.text = menu?[section].label
        header.index = section
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    // Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let current = selectedCategoryIndex, current == section else {
            return 0
        }
        return menu![section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MenuItem
        let item = menu?[indexPath.section].items[indexPath.row]
        cell?.itemName.text = menu?[indexPath.section].items[indexPath.row].name
        let prices = item?.sizes.values.filter({$0 != 0})
        if let min = prices?.min(), let max = prices?.max(){
            if min == max{
                cell?.itemPrice.text = "\(max) EGP"
            }else {
                cell?.itemPrice.text = "\(min) - \(max) EGP"
            }
        }
        
        //Highlighting cell if item was selected
        cell?.accessoryType = .none
        cell?.backgroundColor = UIColor.white
        for orderItem in orderItems{
            if orderItem.item.id == item?.id{
                cell?.accessoryType = .checkmark
                cell?.backgroundColor = UIColor.lightGray
            }
        }
        return cell!
    }
    
    
    // MARK: - View Actions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexes: \(self.selectedIndexes.count)")
        print("Items : \(self.orderItems.count)")
        // Remove item from order if selected before
        if let index = selectedIndexes.index(of: indexPath){
            selectedIndexes.remove(at: index)
            for item in orderItems{
                if menu?[indexPath.section].items[indexPath.row].id == item.item.id{
                    orderItems.remove(at: index)
                }
            }
            self.contentTable.reloadRows(at: [indexPath], with: .automatic)
            return
        }
        
        // Opting user to select desired size
        let item = menu![indexPath.section].items[indexPath.row]
        
        if item.sizes.count == 1{
            addItemToOrder(index: indexPath, size: (item.sizes.first?.key)!)
            self.selectedIndexes.append(indexPath)
            self.contentTable.reloadRows(at: [indexPath], with: .automatic)
        }else{
            let sizesPicker = UIAlertController(title: item.name, message: nil, preferredStyle: .actionSheet)
            for size in item.sizes {
                if size.value != 0 {
                    let size = UIAlertAction(title: "\(size.key) \t - \t \(size.value) EGP" , style: .default, handler: { action in
                        self.addItemToOrder(index: indexPath, size: size.key)
                        self.selectedIndexes.append(indexPath)
                        self.contentTable.reloadRows(at: [indexPath], with: .automatic)
                    })
                    sizesPicker.addAction(size)
                }
            }
            
            //Adding Cancel action to action sheet
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            cancel.setValue(UIColor.red, forKey: "titleTextColor")
            sizesPicker.addAction(cancel)
            
            //presenting the sizes picker
            present(sizesPicker, animated: true, completion: nil)
        }
    }
    
    // Add the item to the Order list
    private func addItemToOrder(index: IndexPath, size: String){
        print("\(index) \(size)")
        orderItems.append(OrderItem(item: menu![index.section].items[index.row], size: size, count: 1))
    }
    
    // User pressed done button
    @IBAction func finalizeAction(_ sender: Any) {
        print("final order \(selectedIndexes), item: \(orderItems)")
        performSegue(withIdentifier: confirmSegueID, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let confirmView = segue.destination as? ConfirmOrderViewController{
            confirmView.owner = self.owner
            confirmView.venue = self.venue
            confirmView.orderItems = self.orderItems
        }
    }
}


    // MARK: extending CategoryHeaderDelegate

extension MenuViewController: CategoryHeaderDelegate {
    func userTappedSectoinWithIndex(_ index: Int) {
        let selected = selectedCategoryIndex
        selectedCategoryIndex = nil
        
        // if section was open -> reload to close it
        if let selected = selected{
            contentTable.reloadSections(NSIndexSet(index: selected) as IndexSet, with: .automatic)
        }
        
        // tapped open section -> Closed already
        if selected == index{
            return
        }else{
            // tapped on another section -> expand it after the expanded one collapse
            if let _ = selected{
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300) , execute: {
                    self.selectedCategoryIndex = index
                    self.contentTable.reloadSections(NSIndexSet(index: index) as IndexSet, with: .automatic)
                })
            }else{
                self.selectedCategoryIndex = index
                self.contentTable.reloadSections(NSIndexSet(index: index) as IndexSet, with: .automatic)
            }
        }
    }
}

//MARK: - MenuItem Cell

class MenuItem: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
}

//MARK: - CollapsibleTableViewHeader

protocol CategoryHeaderDelegate {
    func userTappedSectoinWithIndex(_ index: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    let titleLabel = UILabel()
    var delegate: CategoryHeaderDelegate?
    var index: Int?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView(){
        // Content View
        contentView.backgroundColor = UIColor.blue
        let marginGuide = contentView.layoutMarginsGuide
        
        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: 0.12)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        
        // Gesture recognizer
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
    }
    
    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let header = gestureRecognizer.view as? CollapsibleTableViewHeader, let index = header.index else {
            return
        }
        delegate?.userTappedSectoinWithIndex(index)
    }
}
