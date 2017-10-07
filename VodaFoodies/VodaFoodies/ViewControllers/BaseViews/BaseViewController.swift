//
//  BaseViewController.swift
//  VodaFoodies
//
//  Created by Michael Attia on 8/5/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var loadingDelegate: LoadingTableDelegate?
    
    func fillTable(_ table: UITableView, withTempCell cellType: TempCell){
        table.allowsSelection = false
        table.isScrollEnabled = false
        table.estimatedRowHeight = 90
        table.rowHeight = UITableViewAutomaticDimension
        if let delegate = loadingDelegate {
            table.delegate = delegate
            table.dataSource = delegate
            table.reloadData()
        }else{
            loadingDelegate = LoadingTableDelegate(tableView: table, cellType: cellType)
            table.delegate = loadingDelegate
            table.dataSource = loadingDelegate
        }
    }
    
    func fillTable(_ table: UITableView, withObject object: UITableViewDelegate & UITableViewDataSource){
        table.delegate = object
        table.dataSource = object
        table.isScrollEnabled = true
        table.allowsSelection = true
        table.reloadData()
    }

}
